//
//  Utilities.swift
//  MTL
//
//  Created by Bogdan Grozyan on 22.04.2021.
//

// ApiKey = 25c6029c1f7c22b43349255ec73021e9
import UIKit

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

struct Movie: Decodable, Hashable {
    let id: Int
    var name: String
//    let mediaType: String
    let releaseDate: String?
    var watchStatment: WatchStatments
    var posterImageURL: URL?
    var posterImage: UIImage?
    var popularity: Double?
    var voteAverage: Double?
    let overview: String?
    private enum codingKeys: String, CodingKey {
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case id
        case voteAverage = "vote_average"
        case popularity
        case overview
    }
    
    init(from decoder: Decoder) throws {
        let conteiner = try decoder.container(keyedBy: codingKeys.self)
        name = try conteiner.decode(String.self, forKey: .title)
        voteAverage = try? conteiner.decode(Double.self, forKey: .voteAverage)
        popularity = try? conteiner.decode(Double.self, forKey: .popularity)
        overview = try? conteiner.decode(String.self, forKey: .overview)
        let date = try? conteiner.decode(String.self, forKey: .releaseDate)
        releaseDate = date?.convertToBeautifulDateFormate()
        watchStatment = .none
        id = try conteiner.decode(Int.self, forKey: .id)
//        mediaType = try conteiner
        
        let posterPath = try? conteiner.decode(String.self, forKey: .posterPath)
        if posterPath != nil {
            posterImageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath!)")
        }
    }
    
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
    
    init() {
        name = "Where's movie?"
        voteAverage = nil
        popularity = nil
        overview = nil
        releaseDate = nil
        watchStatment = .none
        id = 1
        posterImageURL = nil
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

// MARK: Genre
struct Genre: Decodable {
    let id: Int
    let name: String
}

// MARK: Keywords
/// https://api.themoviedb.org/3/movie/1927/keywords?api_key=25c6029c1f7c22b43349255ec73021e9
struct KeywordsResponse: Decodable {
    let keywords: [Keyword]?
    
    let totalPages: Int?
    
    private enum CodingKeys: String, CodingKey {
        case keywords
        case totalPages = "total_pages"
     }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        keywords = try container.decode([Keyword].self, forKey: .keywords)
        totalPages = try? container.decode(Int.self, forKey: .totalPages)
    }
}

struct Keyword: Decodable {
    let id: Int
    let name: String
}

// MARK: Cast
///https://api.themoviedb.org/3/movie/1927/credits?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-US
struct MovieTeamResponse: Decodable {
    let cast: [Person]
    let crew: [Person]
}

struct AllPersonData {
    let person: Person
    let ids: PersonExternalIDsResponse
}

struct PeoplesResponse: Decodable {
    let people: [Person]?
    let totalPages: Int?
    
    private enum CodingKeys: String, CodingKey {
        case people = "results"
        case totalPages = "total_pages"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        people = try container.decode([Person].self, forKey: .people)
        totalPages = try? container.decode(Int.self, forKey: .totalPages)
    }
}

struct Person: Decodable {
    let id: Int?
    let name: String?
    let overview: String?
    let deportament: String?
    var profileImage: UIImage?
    let profileImageURL: URL?
    let popularity: Double?
    let character: String?
    let job: String?
    enum CodingKeys: String, CodingKey {
        case overview
        case id
        case name
        case deportament = "known_for_department"
        case profileImagePath = "profile_path"
        case popularity
        case character
        case job
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        overview = try? container.decode(String.self, forKey: .overview)
        deportament = {
            let deportament = try? container.decode(String.self, forKey: .deportament)
            if deportament == "Acting" { return "Actor" }
            return deportament
        }()
        job = try? container.decode(String.self, forKey: .job)
        character = try? container.decode(String.self, forKey: .character)
        popularity = try? container.decode(Double.self, forKey: .popularity)
        
        let posterPath = try? container.decode(String.self, forKey: .profileImagePath)
        if posterPath != nil {
            profileImageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath!)")
        } else {
            profileImageURL = nil
        }
        profileImage = nil
    }
}
// MARK: - External ID
///    https://api.themoviedb.org/3/person/47/external_ids?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-Us
struct PersonExternalIDsResponse: Decodable {
    let imdb: String?
    let facebook: String?
    let twitter: String?
    let instagram: String?
    
    private enum CodingKeys: String, CodingKey {
        case imdb = "imdb_id"
        case facebook = "facebook_id"
        case twitter = "twitter_id"
        case instagram = "instagram_id"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imdb = try? container.decode(String.self, forKey: .imdb)
        facebook = try? container.decode(String.self, forKey: .facebook)
        twitter = try? container.decode(String.self, forKey: .twitter)
        instagram = try? container.decode(String.self, forKey: .instagram)
    }
}

// MARK: - Account

// MARK: Token
extension DataProvider {
   struct AuthenticationToken: Codable {
       let success: Bool
       let expires_at: String
       let requestToken: String
   }
}


// MARK: WatchStatments
enum WatchStatments: Int32 {
    case none
    case wanted
    case watched
}

// MARK: Movie Type Enum
enum MovieType {
    case recommended
    case topRated
    case nowPlaying
    case upcoming
    case popular
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
}

struct Pages {
    var currentPage: Int
    var maxPages: Int
    lazy var isCanSearchForNextPage = checkIsCurrentPageLestThanMaxPages()
    private func checkIsCurrentPageLestThanMaxPages() -> Bool {
        return currentPage < maxPages
    }
}

extension SearchViewController {
    enum sectionType {
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
// MARK: Discrover

// https://developers.themoviedb.org/3/discover/movie-discover
//Params:
/*
 sort_by
 page
 with_cast
 with_crew
 with_people
 with_genre
 with_keywords
 */

// MARK: Search by movie name
///https://api.themoviedb.org/3/search/movie?api_key=25c6029c1f7c22b43349255ec73021e9&query=Hulk&page=1

// MARK: Search person by name
///https://api.themoviedb.org/3/search/person?api_key=25c6029c1f7c22b43349255ec73021e9&query=robert&page=1
struct SearchPersonResponse: Decodable {
    let page: Int
    let results: [Person]?
}

// MARK: Search by person id
///https://api.themoviedb.org/3/person/12835/movie_credits?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-US

// MARK: Search by keywords name and id
///https://api.themoviedb.org/3/search/keyword?api_key=25c6029c1f7c22b43349255ec73021e9&query=ho&page=1
