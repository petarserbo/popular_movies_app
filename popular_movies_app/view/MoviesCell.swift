//
//  MoviesCell.swift
//  popular_movies_app
//
//  Created by Petar Perich on 21.06.2021.
//

import UIKit

class MoviesCell: UITableViewCell {
    
    static let identifier = "MoviesCell"
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var raitingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    private var urlString: String = ""
    
    
    func setCellWithValuesOf(_ movie: Movie) {
        updateUI(title: movie.title, releaseDate: movie.year, rating: movie.rate, poster: movie.posterImage, overView: movie.overview)
    }
    
    private func updateUI(title: String?, releaseDate: String?, rating: Double?, poster: String?, overView: String?) {
        
        self.movieTitleLabel.text = title
        self.overviewLabel.text = overView
        guard let rate = rating else {return}
        self.raitingLabel.text = String(rate)
        
        
        guard let posterString = poster else {return}
        urlString = "https://image.tmdb.org/t/p/w300" + posterString
        
        guard let posterImageURL = URL(string: urlString) else {
            self.poster.image = UIImage(named: "noImageAvailable")
            return
        }
        
        self.poster.image = nil
        getImageDataFrom(url: posterImageURL)
        
    }
    
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("Data task error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("No data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.poster.image = image
                }
            }
        }
        .resume()
    }
}
