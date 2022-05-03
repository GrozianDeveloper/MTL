//
//  MovieModels.swift
//  MTL
//
//  Created by Bogdan Grozian on 03.05.2022.
//

import Foundation
import UIKit.UIImage
// MARK: - Movie

///https://api.themoviedb.org/3/person/12835/movie_credits?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-US  By Person
///https://api.themoviedb.org/3/movie/299534/recommendations?api_key=25c6029c1f7c22b43349255ec73021e9&page=1 By ID
struct MoviesResponse: Decodable {
    var results: [Movie]?
    
    var totalPages: Int?
    enum codingKeys: String, CodingKey {
        case moviesById = "results"
        case totalPages = "total_pages"
        case moviesByPerson = "cast"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)
        results = try? container.decode([Movie].self, forKey: .moviesById)
        if results == nil {
            results = try? container.decode([Movie].self, forKey: .moviesByPerson)
        }
        totalPages = try? container.decode(Int.self, forKey: .totalPages)
    }
}

final class Movie: Decodable, Hashable {
    
    let id: Int
    var name: String
    let releaseDate: String?
    var watchStatment: WatchStatments
    var posterImageURL: URL?
    var posterImage: UIImage?
    var popularity: Double?
    var voteAverage: Double?
    let overview: String?
    
    init(movieCoreData: MovieCoreData) {
        self.id = Int(movieCoreData.id)
        self.name = movieCoreData.name ?? "name"
        self.releaseDate = movieCoreData.releaseDate
        self.watchStatment = WatchStatments(rawValue: movieCoreData.watchStatmentRawValue) ?? .none
        if let data = movieCoreData.posterImageData {
            self.posterImage = UIImage(data: data)
        }
        popularity = movieCoreData.popularity
        voteAverage = movieCoreData.voteAverage
        overview = movieCoreData.overview
    }
    
    private init() {
        name = "Where's movie?"
        voteAverage = nil
        popularity = nil
        overview = nil
        releaseDate = nil
        watchStatment = .none
        id = 1
        posterImageURL = nil
    }
    
    required init(from decoder: Decoder) throws {
        let conteiner = try decoder.container(keyedBy: codingKeys.self)
        name = try conteiner.decode(String.self, forKey: .title)
        voteAverage = try? conteiner.decode(Double.self, forKey: .voteAverage)
        popularity = try? conteiner.decode(Double.self, forKey: .popularity)
        overview = try? conteiner.decode(String.self, forKey: .overview)
        let date = try? conteiner.decode(String.self, forKey: .releaseDate)
        releaseDate = date?.convertToBeautifulDateFormate()
        watchStatment = .none
        id = try conteiner.decode(Int.self, forKey: .id)
        
        let posterPath = try? conteiner.decode(String.self, forKey: .posterPath)
        if posterPath != nil {
            posterImageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath!)")
        }
    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    private enum codingKeys: String, CodingKey {
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case id
        case voteAverage = "vote_average"
        case popularity
        case overview
    }
}

// MARK: MovieData
struct MoviesData {
    let type: MovieType?
    var movies: [Movie]?
    var pages: Pages
    
    init(type: MovieType?, movies: [Movie]?, currentPage: Int, maxPages: Int) {
        self.type = type
        self.movies = movies
        self.pages = Pages(currentPage: currentPage, maxPages: maxPages)
    }
    init() {
        self.type = nil
        self.movies = nil
        self.pages = Pages(currentPage: 0, maxPages: 0)
    }
    init(type: MovieType) {
        self.type = type
        self.movies = nil
        self.pages = Pages(currentPage: 0, maxPages: 0)
    }
    
    struct Pages {
        var currentPage: Int
        var maxPages: Int
        lazy var isCanSearchForNextPage = checkIsCurrentPageLestThanMaxPages()
        private func checkIsCurrentPageLestThanMaxPages() -> Bool {
            return currentPage < maxPages
        }
    }
}

// MARK: Movie Description
/// https://api.themoviedb.org/3/movie/299534?api_key=25c6029c1f7c22b43349255ec73021e9&append_to_response=keywords
struct DescriptionMovieResponse: Decodable {
    let genres: [Genre]?
    let keywords: [Keyword]?
    let homePage: String?
    let imdb: String?
    
    enum codingKeys: String, CodingKey {
        case genres
        case keywords
        case homePage = "homepage"
        case imdb = "imdb_id"
     }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)
        genres = try? container.decode([Genre].self, forKey: .genres)
        homePage = try? container.decode(String.self, forKey: .homePage)
        imdb = try? container.decode(String.self, forKey: .imdb)
        let keywordsHolder = try? container.decode(KeywordsResponse.self, forKey: .keywords)
        keywords = keywordsHolder?.keywords
    }
}

// MARK: WatchStatments
enum WatchStatments: Int32 {
    case none
    case wanted
    case watched
}

// MARK: Movie Type Enum
enum MovieType: CaseIterable {
    case recommended
    case nowPlaying
    case upcoming
    case popular
    case topRated
    /// Find by liked movies genre
    case similar
    var pathForURL: String {
        switch self {
        case .recommended: return "recommendations"
        case .nowPlaying: return "now_playing"
        case .popular: return "popular"
        case .topRated: return "top_rated"
        case .upcoming: return "upcoming"
        case .similar: return "similar"
        }
    }
    var title: String {
        switch self {
        case .recommended: return "For you"
        case .nowPlaying: return "Now Playing"
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        case .upcoming: return "Upcoming"
        case .similar: return "Similar"
        }
    }
}

fileprivate extension String {
    /// "yyyy-MM-dd" to "d MMMM yyyy"
    func convertToBeautifulDateFormate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = "d MMMM yyyy"
        return  dateFormatter.string(from: date)
    }
}
