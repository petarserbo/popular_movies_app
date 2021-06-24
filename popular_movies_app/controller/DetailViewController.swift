//
//  DetailViewController.swift
//  popular_movies_app
//
//  Created by Petar Perich on 22.06.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var secondScreenPoster: UIImageView!
    @IBOutlet weak var secondScreenTitle: UILabel!
    @IBOutlet weak var secondScreenRaiting: UILabel!
    @IBOutlet weak var secondScreenRelease: UILabel!
    @IBOutlet weak var secondScreenOverview: UITextView!
    
    var movieItem: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    func configure(){
        secondScreenPoster.load(url: URL(string: "https://image.tmdb.org/t/p/w500" + movieItem.posterImage!)!)
        secondScreenTitle.text = movieItem.title
        secondScreenRaiting.text = String(movieItem.rate!) + "♥️"
        secondScreenRelease.text = movieItem.year
        secondScreenOverview.text = movieItem.overview
        
    }
}

extension UIImageView {
    func load (url: URL) {
        NetworkService.loadImage(from: url) { [weak self] (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
