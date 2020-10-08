//
//  MovieDetailsViewController.swift
//  Popular Movies
//
//  Created by Niso on 10/3/20.
//  Copyright © 2020 Niso. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    var viewModel: MovieDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Back button color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        updateUI()
    }
    
    // Update UI
    private func updateUI() {
        self.movieTitle.text = viewModel.title
        self.movieRate.text = viewModel.rate
        self.movieReleaseDate.text = viewModel.year
        self.movieOverview.text = viewModel.overview
        self.moviePoster.setImageFromPath(viewModel.posterImage)
        viewsAttributes()
    }
    
    //MARK: - Views attributes
    private func viewsAttributes() {
        movieRate.layer.masksToBounds = true
        movieRate.layer.cornerRadius = 15
    }
}

// Extension to set an image into UIImageView
extension UIImageView {
    func setImageFromPath(_ path: String?) {
        image = nil
        DispatchQueue.global(qos: .background).async {
            var image: UIImage?
            guard let imagePath = path else {return}
            if let imageURL = URL(string: imagePath) {
                if let imageData = NSData(contentsOf: imageURL) {
                    image = UIImage(data: imageData as Data)
                } else {
                    // Image default - In case of error
                    image = UIImage(named: "noImageAvailable")
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
