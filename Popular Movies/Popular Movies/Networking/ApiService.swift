//
//  ApiService.swift
//  Popular Movies
//
//  Created by Niso on 10/3/20.
//  Copyright © 2020 Niso. All rights reserved.
//

import Foundation

class ApiService {
    
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Get popular movies data
    func getPopularMoviesData(completion: @escaping (Result<MoviesData, Error>) -> Void) {
        
        let popularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=4e0be2c22f7268edffde97481d49064a&language=en-US&page=1"
        
        guard let url = URL(string: popularMoviesURL) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Hndle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
    
    //MARK: - Get image data
    func getImageDataFrom(url:URL, completion: @escaping ((Data) -> Void)) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}
