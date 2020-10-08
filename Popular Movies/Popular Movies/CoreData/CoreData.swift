//
//  CoreData.swift
//  Popular Movies
//
//  Created by Niso on 10/3/20.
//  Copyright © 2020 Niso. All rights reserved.
//

import UIKit
import CoreData

class CoreData {
    
    static let sharedInstance = CoreData()
    private init(){}
    
    private let continer: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private let fetchRequest = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    
    func saveDataOf(movies:[Movie]) {
        
        // Updates CoreData with the new data from the server - Off the main thread
        self.continer?.performBackgroundTask{ [weak self] (context) in
            self?.deleteObjectsfromCoreData(context: context)
            self?.saveDataToCoreData(movies: movies, context: context)
        }
    }
    
    // MARK: - Delete Core Data objects before saving new data
    private func deleteObjectsfromCoreData(context: NSManagedObjectContext) {
        do {
            // Fetch Data
            let objects = try context.fetch(fetchRequest)
            
            // Delete Data
            _ = objects.map({context.delete($0)})
            
            // Save Data
            try context.save()
        } catch {
            print("Deleting Error: \(error)")
        }
    }
    
    // MARK: - Save new data from the server to Core Data
    private func saveDataToCoreData(movies:[Movie], context: NSManagedObjectContext) {
        // perform - Make sure that this code of block will be executed on the proper Queue
        // In this case this code should be perform off the main Queue
        context.perform {
            for movie in movies {
                let movieEntity = MovieEntity(context: context)
                movieEntity.title = movie.title
                movieEntity.year = movie.year
                guard let rate = movie.rate else {return}
                movieEntity.rate = String(rate)
                movieEntity.posterImage = movie.posterImage
                movieEntity.backdropImage = movie.backdropImage
                movieEntity.overview = movie.overview
            }
            // Save Data
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
}
