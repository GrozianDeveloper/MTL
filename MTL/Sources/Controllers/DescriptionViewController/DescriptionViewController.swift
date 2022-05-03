//
//  DescriptionViewController.swift
//  MTL
//
//  Created by Bogdan Grozyan on 27.04.2021.
//  Recreated by Bogdan Grozyan on 08.05.2021.
//

import UIKit
import CoreData

final class DescriptionViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let movie: Movie
    var movieStatment: WatchStatments {
        didSet {
            movie.watchStatment = movieStatment
            switch movieStatment {
            case .none:
                deleteMovieFromCoreData()
            default:
                (currentMovieCoreData != nil) ? updateMovieStatment(toStatment: movieStatment) : createMovieCoreDataItem()
            }
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.reloadSections([0], with: .none)
            }
        }
    }
    
    init(movie: Movie) {
        self.movieStatment = movie.watchStatment
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
        getMovieData()
    }
    
    init(movie: MovieCoreData) {
        self.movie = Movie(movieCoreData: movie)
        self.movieStatment = self.movie.watchStatment
        super.init(nibName: nil, bundle: nil)
        self.getMovieData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Where the movie?")
    }
    
    var currentMovieCoreData: MovieCoreData?
    
    var lastOnlineActivityCellThatWasTapped: OnlineActivityCell = .sentToFriend
    var imdbURL: URL?
    var dataProvider = DataProvider.shared
    
    var movieTeam: [Person]?
    var relatedMovies: [Movie]?
    var movieDescripthion: DescriptionMovieResponse?
    
    var personDescription = [Person]()
    var personIDs = [PersonExternalIDsResponse]()
    
    var sections = SectionType.allCases
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 30
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        indicator.layer.zPosition = 1
        return indicator
    }()
}

// MARK: Get Movie
private extension DescriptionViewController {
    private func getMovieData() {
        if movie.posterImage == nil, let url = movie.posterImageURL {
            dataProvider.getImageWithCaching(url: url) { [weak self] image in
                self?.movie.posterImage = image
                UIView.performWithoutAnimation { [weak self] in
                    self?.tableView.reloadSections([0], with: .none)
                }
            }
        }
        dataProvider.GetFullyMovieDescription(movieID: self.movie.id) { [weak self] recivedData in
            guard let self = self else { return }
            switch recivedData {
            case .success(let result):
                self.movieDescripthion = result
                if let imdb = self.movieDescripthion?.imdb {
                    self.imdbURL = URL(string: "https://www.imdb.com/title/\(imdb)/")
                    if self.activityIndicator.isAnimating {
                        switch self.lastOnlineActivityCellThatWasTapped {
                        case .watchOnline:
                            self.presentSafariViewController(url: self.imdbURL!)
                        case .sentToFriend:
                            self.shareContent(items: [self.imdbURL!])
                            self.tableView.deselectRow(at: [3, 0], animated: true)
                        }
                    }
                    self.activityIndicator.stopAnimating()
                    UIView.performWithoutAnimation { [weak self] in
                        self?.tableView.reloadSections([5], with: .none) // Genres
                        self?.tableView.reloadSections([6], with: .none) // Keywords
                    }
                } else {
                    self.sections.remove(at: 6)
                    self.sections.remove(at: 5)
                    self.sections.remove(at: 3)
                    self.sections.remove(at: 2)
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print("error", error)
            }
        }
        dataProvider.getMovieCast(id: self.movie.id) { [weak self] recivedData in
            switch recivedData {
            case .success(let result):
                guard let self = self else {
                    return
                }
                self.movieTeam = result.cast
                for a in 0...7 {
                    if let url = self.movieTeam?[a].profileImageURL {
                        self.dataProvider.getImageWithCaching(url: url, completion: {
                            self.movieTeam?[a].profileImage = $0
                        })
                    }
                    UIView.performWithoutAnimation { [weak self] in
                        self?.tableView.reloadSections([7], with: .none)
                    }
                }
            case .failure(let error):
                print("error", error)
            }
        }
        
        dataProvider.getMovies(pagination: false, type: .recommended, movieId: self.movie.id, page: 1) { [weak self] recivedData in
            switch recivedData {
            case .success(let result):
                guard let self = self else {
                    return
                }
                self.relatedMovies = result.results
                UIView.performWithoutAnimation { [weak self] in
                    self?.tableView.reloadSections([8], with: .none)
                }
            case .failure(let error):
                print("error", error)
            }
        }
    }
}

// MARK: - Models
extension DescriptionViewController {
    enum SectionType: CaseIterable {
        case movieStatments
        case votePopularity
        case watchOnline
        case sentToFriend
        case overview
        case genres
        case keywords
        case team
        case relatedMovies
        var HeaderTitle: String {
            switch self {
            case .genres: return "Genres"
            case .keywords: return "Keywords"
            case .overview: return "Sinopsis"
            case .team: return "Cast & Crew"
            case .relatedMovies: return "Related Movies"
            default:
                return "" // This message will never happend
            }
        }
    }
    
    enum OnlineActivityCell {
        case watchOnline
        case sentToFriend
    }
}
