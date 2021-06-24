//
//  ViewController.swift
//  popular_movies_app
//
//  Created by Petar Perich on 21.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPopularMoviesData{ [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.delegate = self
            self?.tableView.reloadData()
        }
    }
    
    func fetchPopularMoviesData(completion: @escaping () -> ()) {
        
        NetworkService.getMovies { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.movies = listOf.movies
                completion()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: error.localizedDescription)
                    print("Error processing data: \(error)")
                }
                
            }
        }
    }
    
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviesCell.identifier, for: indexPath) as! MoviesCell
        
        let movieInfo = movies[indexPath.row]
        cell.setCellWithValuesOf(movieInfo)
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieItem = movies[indexPath.row]
        performSegue(withIdentifier: "ShowDetail", sender: movieItem)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let secondVC = segue.destination as? DetailViewController,
                  let ourMovies = sender as? Movie
            else {
                fatalError("wrong")
            }
            secondVC.movieItem = ourMovies
            
        }
    }
}
