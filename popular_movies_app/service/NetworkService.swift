//
//  Networking.swift
//  popular_movies_app
//
//  Created by Petar Perich on 21.06.2021.
//

import Foundation
import UIKit

class NetworkService {
    
    static func getMovies(completion: @escaping (Result<MoviesData, Error>)-> Void){
        
        let popularMoviesURL =  "https://api.themoviedb.org/3/movie/popular?api_key=947a4d4411e89734aa402857f2bf0fe3"
        
        guard let url = URL(string: popularMoviesURL) else {return}
        var dataTask: URLSessionDataTask?
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                
                print("Empty Data")
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data)
                
                
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
    
    static func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
            
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                if let data = data {
                    completion(UIImage(data: data))
                } else {
                    completion(nil)
                }
                
            }
        }
        .resume()
    }
}



