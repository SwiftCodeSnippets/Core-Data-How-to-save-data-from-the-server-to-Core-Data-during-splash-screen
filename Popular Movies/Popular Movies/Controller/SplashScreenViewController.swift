//
//  SplashScreenViewController.swift
//  Popular Movies
//
//  Created by Niso on 10/3/20.
//  Copyright © 2020 Niso. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    private var apiService = ApiService()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadPopularMoviesData()
    }
    
    private func loadPopularMoviesData() {
        
        // Fetch data from the server
        apiService.getPopularMoviesData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                // Save data to Core Data
                CoreData.sharedInstance.saveDataOf(movies: listOf.movies)
                self?.perform(#selector(self?.mainScreen))
            case .failure(let error):
                // Show alert message in case of error
                self?.showAlertWith(title: "Could Not Connect!", message: "Please check your internet connection \n or try again later")
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
    
    // MARK: - Alert message
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Perform a transition to the main screen (MoviesListViewController)
    @objc func mainScreen() {
        performSegue(withIdentifier: "moviesList", sender: self)
    }
}
