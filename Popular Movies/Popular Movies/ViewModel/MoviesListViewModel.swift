//
//  MoviesListViewModel.swift
//  Popular Movies
//
//  Created by Niso on 10/3/20.
//  Copyright © 2020 Niso. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol UpdateTableViewDelegate: NSObjectProtocol {
    func reloadData(sender: MoviesListViewModel)
}

class MoviesListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var fetchedResultsController: NSFetchedResultsController<MovieEntity>?
    
    weak var delegate: UpdateTableViewDelegate?
    
    //MARK: - Fetched Results Controller - Retrieve data from Core Data
    func retrieveDataFromCoreData() {
        
        if let context = self.container?.viewContext {
            let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            
            // Sort movies by rating
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(MovieEntity.rate), ascending: false)]
            
            self.fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            // Notifies the tableView when any changes have occurred to the data
            fetchedResultsController?.delegate = self
            
            // Fetch data
            do {
                try self.fetchedResultsController?.performFetch()
            } catch {
                print("Failed to initialize FetchedResultsController: \(error)")
            }
        }
    }
    
    // Changes have happened in fetchedResultsController so we need to notify the tableView
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Update the tableView
        self.delegate?.reloadData(sender: self)
    }
    
    //MARK: - TableView DataSource functions
    func numberOfRowsInSection (section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func object (indexPath: IndexPath) -> MovieEntity? {
        return fetchedResultsController?.object(at: indexPath)
    }
}
