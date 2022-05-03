//
//  SearchViewController.swift
//  MTL
//
//  Created by Bogdan Grozyan on 28.05.2021.
//

import UIKit

final class SearchViewController: UIViewController {
    
    let dataProvider = DataProvider.shared
    
    var isNowSearching: Bool {
        didSet {
            if !isNowSearching {
                searchBar.placeholder = "Search"
                filteredMovies = suggestedMovies
                filteredKeywords = dataProvider.allKeywords
                filteredPeople = popularPeople
                sections = SectionType.allCases
            }
        }
    }

    init() {
        self.isNowSearching = false
        super.init(nibName: "SearchViewController", bundle: nil)
        onceInWeekGetData()
    }
    
    init(SearchByGenre genre: Genre) {
        self.isNowSearching = false
        super.init(nibName: "SearchViewController", bundle: nil)
        searchByGenre(genre: genre, page: 1)
    }
    
    init(SearchByKeyword keyword: Keyword) {
        self.isNowSearching = true
        super.init(nibName: "SearchViewController", bundle: nil)
        searchByKeyword(keyword: keyword, page: 1)
    }
    
    required init?(coder: NSCoder) {
        self.isNowSearching = false
        super.init(nibName: "SearchViewController", bundle: nil)
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var sections = SectionType.allCases
    
    private var wantedAndWatchedMoviesID = [1726, 27205, 99861, 440472, 218, 339403]
    
    // for scroll to item when !isNowSearching
    private let lastVisibleSuggestedMovieCellIndex: IndexPath = [0, 13]
    private let lastVisibleAllKeywordCellIndex: IndexPath = [2, 30]
    private let lastVisiblePopularPeopleCellIndex: IndexPath = [0, 13]
    
    // filtered will Presented
    // others will store data while searching
    var filteredMovies: [Movie]?
    var suggestedMovies = [Movie]()
    
    let allGenres = DataProvider.shared.allGenres
    
    var filteredKeywords: [Keyword]? = DataProvider.shared.allKeywords
    
    var popularPeople = [Person]()
    var filteredPeople: [Person]?
    
    var searchText: String = ""
}

// MARK: - Support
extension SearchViewController {
    private func onceInWeekGetData() {
        for movieId in wantedAndWatchedMoviesID {
            dataProvider.getMovies(pagination: false, type: .recommended, movieId: movieId, page: 1) { [weak self] recivedData in
                guard let self = self else { return }
                switch recivedData {
                case .success(let movies):
                    guard var movies = movies.results else { return }
                    movies = movies.filter { $0.popularity != nil }
                    movies.sort { $0.popularity! > $1.popularity! }

                    self.suggestedMovies.append(contentsOf: movies)
                    self.suggestedMovies = self.suggestedMovies.removeDuplicated()
                    if !self.isNowSearching {
                        self.filteredMovies = self.suggestedMovies
                    }
                    UIView.performWithoutAnimation { [weak self] in
                        self?.tableView.reloadSections([0], with: .none)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }

        for page in 1...4 {
            getPopularPeople(page: page)
        }
        // Safe to offline storage
    }
}

// MARK: - Models
extension SearchViewController {
    enum SectionType: CaseIterable {
        case movies
        
        case genres
        case keywords
        case people

        var sectionTitle: String {
            switch self {
            case .movies: return "Suggested"
            case .genres: return "Genres"
            case .keywords: return "Keywords"
            case .people: return "People"
            }
        }

        var sectionOrder: Int {
            switch self {
            case .movies: return 1
            case .genres: return 2
            case .keywords: return 3
            case .people: return 4
            }
        }
    }
}


fileprivate extension Sequence where Element: Hashable {
    func removeDuplicated() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
