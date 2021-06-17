//
//  NetworkManager.swift
//  MTL
//
//  Created by Bogdan Grozyan on 24.04.2021.
//

import Network
import UIKit

final class DataProvider {
    
// MARK: Singleton
    static var shared = DataProvider(apiKey: "25c6029c1f7c22b43349255ec73021e9")
    
    private init(apiKey: String) {
        self.apiKey = apiKey
    }
// MARK: Property's
    private let apiKey: String
    
    private let decodingQueue = DispatchQueue(label: "com.MTL.decoding")
    
    private let requestQueue = DispatchQueue(label: "com.MTL.url.requesting")
    
    private let imageQueue = DispatchQueue(label: "com.MTL.image.getting")
    
    var isPaginating = false
    
    private enum RequestErrors: Error {
        case dataStructureError
        case somethingWithResponse
        case paginatingAlreadyInRun
    }
    
    var tmdbURLComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        return urlComponents
    }()
    
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    public var imageCache = NSCache<NSString, UIImage>()
    
    public func getImageWithCaching(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let chachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(chachedImage)
        } else {
            imageQueue.async { [ weak self ] in
                let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let self = self else {
                        return
                    }
                    guard error == nil,
                          let response = response as? HTTPURLResponse,
                          response.statusCode == 200,
                          let data = data else {
                        completion(nil)
                        return
                    }
                    guard let image = UIImage(data: data) else { return }
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
                dataTask.resume()
            }
        }
    }
    
    private func getDecodedDataFromURLSession<T: Decodable>(url: URL, FromSnakeKeys: Bool, as type: T.Type, completion: @escaping( Result<T, Error>) -> ()) {
        requestQueue.async { [weak self] in
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let self = self else {
                    return
                }
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(RequestErrors.somethingWithResponse))
                    return
                }
                guard let data = data else {
                    completion(.failure(RequestErrors.dataStructureError))
                    return
                }
                self.decodingQueue.async {
                    if !FromSnakeKeys {
                        data.decoded(as: T.self) { completion($0)}
                    } else {
                        data.decodedFromSnakeKeys(as: T.self) { recivedData in
                            data.decoded(as: T.self) { completion($0)}
                        }
                    }
                }
            }
            dataTask.resume()
        }
     }
    // MARK: storated properties
    let allGenres: [Genre] = [
        Genre(id: 28, name: "Action"), Genre(id: 12, name: "Adventure"),
        Genre(id: 16, name: "Animation"), Genre(id: 35, name: "Comedy"),
        Genre(id: 80, name: "Crime"), Genre(id: 99, name: "Documentary"),
        Genre(id: 18, name: "Drama"), Genre(id: 10751, name: "Family"),
        Genre(id: 14, name: "Fantasy"), Genre(id: 36, name: "History"),
        Genre(id: 27, name: "Horror"), Genre(id: 37, name: "Western"),
        Genre(id: 10402, name: "Music"), Genre(id: 9648, name: "Mystery"),
        Genre(id: 10749, name: "Romance"), Genre(id: 878, name: "Science Fiction"),
        Genre(id: 10770, name: "TV Movie"), Genre(id: 10752, name: "War"),
        Genre(id: 53, name: "Thriller")
    ]
    
    var allKeywords: [Keyword] = [
        Keyword(id: 275656, name: "aarhus, denmark"),
        Keyword(id: 272696, name: "aaron spelling"),
        Keyword(id: 251510, name: "abba"),
        Keyword(id: 273791, name: "abenteuer"),
        Keyword(id: 276131, name: "aberdeen"),
        Keyword(id: 277543, name: "abode"),
        Keyword(id: 237757, name: "abs"),
        Keyword(id: 272105, name: "abs-cbn news"),
        Keyword(id: 211158, name: "absent parent"),
        Keyword(id: 210626, name: "absinthe"),
        Keyword(id: 209883, name: "absolutism"),
        Keyword(id: 276088, name: "abstention"),
        Keyword(id: 216933, name: "abstinence"),
        Keyword(id: 213891, name: "abstract"),
        Keyword(id: 215853, name: "abstract art"),
        Keyword(id: 252530, name: "absurd"),
        Keyword(id: 226818, name: "absurd humor"),
        Keyword(id: 214655, name: "absurdism"),
        Keyword(id: 210710, name: "absurdist"),
        Keyword(id: 3046, name: "ailul al aswad"),
        Keyword(id: 159094, name: "air base"),
        Keyword(id: 204408, name: "al andalus"),
        Keyword(id: 223518, name: "al ghazali"),
        Keyword(id: 257577, name: "al hussein"),
        Keyword(id: 188507, name: "al qaeda"),
        Keyword(id: 270119, name: "al smith"),
        Keyword(id: 256945, name: "al-asifa"),
        Keyword(id: 270545, name: "al-qaeda"),
        Keyword(id: 248783, name: "alep"),
        Keyword(id: 274144, name: "aleph"),
        Keyword(id: 271869, name: "ales y willy"),
        Keyword(id: 274861, name: "alevi"),
        Keyword(id: 257149, name: "alex"),
        Keyword(id: 239671, name: "alexa"),
        Keyword(id: 229893, name: "als"),
        Keyword(id: 277621, name: "alvar aalto"),
        Keyword(id: 191110, name: "army base"),
        Keyword(id: 270675, name: "b 17 bomber"),
        Keyword(id: 260287, name: "b film"),
        Keyword(id: 269848, name: "b horror"),
        Keyword(id: 11034, name: "b movie"),
        Keyword(id: 245015, name: "b western"),
        Keyword(id: 235584, name: "b-17"),
        Keyword(id: 233885, name: "b-25"),
        Keyword(id: 181210, name: "b-boying"),
        Keyword(id: 155449, name: "b-girl"),
        Keyword(id: 181211, name: "b-girling"),
        Keyword(id: 273549, name: "b/w"),
        Keyword(id: 278251, name: "bam"),
        Keyword(id: 6417, name: "base"),
        Keyword(id: 251768, name: "base camp"),
        Keyword(id: 3605, name: "baseball bat"),
        Keyword(id: 10542, name: "based on toy"),
        Keyword(id: 212398, name: "basel"),
        Keyword(id: 268066, name: "basf"),
        Keyword(id: 238584, name: "bashar"),
        Keyword(id: 211459, name: "bashful"),
        Keyword(id: 252931, name: "basho"),
        Keyword(id: 160314, name: "basket"),
        Keyword(id: 213280, name: "basque"),
        Keyword(id: 193898, name: "bass"),
        Keyword(id: 164353, name: "bassist"),
        Keyword(id: 249755, name: "bastard"),
        Keyword(id: 5155, name: "bat"),
        Keyword(id: 5832, name: "bed and breakfast (b&b)"),
        Keyword(id: 270602, name: "bela b"),
        Keyword(id: 238117, name: "blowing a fuse"),
        Keyword(id: 207864, name: "building a house"),
        Keyword(id: 208051, name: "building a wall"),
        Keyword(id: 240466, name: "cain & abel"),
        Keyword(id: 183203, name: "destroying a car"),
        Keyword(id: 198586, name: "drum and bass"),
        Keyword(id: 280047, name: "eid al-adha"),
        Keyword(id: 218110, name: "farmer al falfa"),
        Keyword(id: 254246, name: "find a job"),
        Keyword(id: 238220, name: "frying a fish"),
        Keyword(id: 180098, name: "group b rally"),
        Keyword(id: 276868, name: "hammam al-hana"),
        Keyword(id: 225905, name: "harold b lee"),
        Keyword(id: 250995, name: "juukou b-fighter"),
        Keyword(id: 249670, name: "leave of absence"),
        Keyword(id: 237434, name: "like a girl"),
        Keyword(id: 239038, name: "making a scene"),
        Keyword(id: 12185, name: "moon base"),
        Keyword(id: 261503, name: "n&b"),
        Keyword(id: 232455, name: "project a"),
        Keyword(id: 179173, name: "quitting a job"),
        Keyword(id: 266948, name: "r&b"),
        Keyword(id: 254624, name: "r&b artist"),
        Keyword(id: 182295, name: "reading a book"),
        Keyword(id: 274402, name: "serie b"),
        Keyword(id: 250204, name: "sharing a bed"),
        Keyword(id: 267840, name: "shaytan al jazzirah"),
        Keyword(id: 188477, name: "slamming a door"),
        Keyword(id: 186399, name: "stealing a chicken"),
        Keyword(id: 271616, name: "taha ki aag"),
        Keyword(id: 211122, name: "taking a shower"),
        Keyword(id: 208658, name: "taking a stand"),
        Keyword(id: 246423, name: "theatre absurde"),
        Keyword(id: 240938, name: "there goes a"),
        Keyword(id: 265584, name: "vuelta al mundo"),
        Keyword(id: 190834, name: "watching a video"),
        Keyword(id: 204384, name: "without a word"),
        Keyword(id: 217002, name: "writing a check"),
        Keyword(id: 260770, name: "wäinö aaltonen")
    ]
}
extension DataProvider {
    
// MARK: Internet checges √
    static func checkingForInternetConnection(completion: @escaping(Bool) -> ()) {
        let queueForConnectionMonitor = DispatchQueue.global()
        let connectionMonitor = NWPathMonitor()
        connectionMonitor.pathUpdateHandler = { path in
            var isConnected = false
            if path.usesInterfaceType(.cellular) || path.usesInterfaceType(.wifi) && path.status == .satisfied {
                isConnected = true
            }
            completion(isConnected)
        }
        connectionMonitor.start(queue: queueForConnectionMonitor)
    }
    
// MARK: Requests
    
    func getMovies(pagination: Bool, type: MovieType, movieId: Int?, page: Int, completion: @escaping(Result<MoviesResponse, Error>) -> ()) {
        if pagination { self.isPaginating = true }
        switch type {
        case .recommended, .similar:
            tmdbURLComponents.path = "/3/movie/\(movieId ?? 522627)/\(type.pathForURL)"
        default:
            tmdbURLComponents.path = "/3/movie/\(type.pathForURL)"
        }
        tmdbURLComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "page", value: String(page))
        ]
        getDecodedDataFromURLSession(url: tmdbURLComponents.url!, FromSnakeKeys: false, as: MoviesResponse.self) { [weak self] recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
                if pagination { self?.isPaginating = false }
            }
        }
    }
    
// MARK: Description √
//    https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&append_to_response=keywords
    func GetFullyMovieDescription(movieID id: Int, completion: @escaping(Result<DescriptionMovieResponse, Error>) ->()) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&append_to_response=keywords")!
        getDecodedDataFromURLSession(url: url, FromSnakeKeys: false, as: DescriptionMovieResponse.self) { recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
            }
        }
    }
    
// MARK: Cast √
//    https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)
    func getMovieCast(id: Int, completion: @escaping(_ result: Result<MovieTeamResponse, Error>) -> ()) {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)")!
        self.getDecodedDataFromURLSession(url: url, FromSnakeKeys: false, as: MovieTeamResponse.self) { recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
            }
        }
    }
    
// MARK: Person IDs √
//    https://api.themoviedb.org/3/person/\(id)/external_ids?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-Us
    func getPersonExternalIDs(id: Int, completion: @escaping(_ result: Result<PersonExternalIDsResponse, Error>) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/person/\(id)/external_ids?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-Us")!
        self.getDecodedDataFromURLSession(url: url, FromSnakeKeys: false, as: PersonExternalIDsResponse.self) { recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
            }
        }
    }
    
    // MARK: Popular people √
//    https://api.themoviedb.org/3/person/popular?api_key=\(apiKey)&page=\(page)
    func getPopularPeople(page: Int,completion: @escaping(_ result: Result<PeoplesResponse, Error>) -> ()) {
        guard page > 1 else {
            return
        }
        let url = URL(string: "https://api.themoviedb.org/3/person/popular?api_key=\(apiKey)&page=\(page)")!
        getDecodedDataFromURLSession(url: url, FromSnakeKeys: false, as: PeoplesResponse.self) { recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
            }
        }
    }
}

// MARK: Search
extension DataProvider {
//MARK: Movies by query
// https://api.themoviedb.org/3/search/movie?api_key=25c6029c1f7c22b43349255ec73021e9&query=IronCan&page=1
    public func searchByQuery(quere: String, page: Int, completion: @escaping(Result<MoviesResponse, Error>) ->()) {
//        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(quere)&page=\(page)")!
        tmdbURLComponents.path = "/3/search/movie"
        tmdbURLComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "query", value: quere),
            URLQueryItem(name: "page", value: String(page))
        ]
        guard let url = tmdbURLComponents.url?.absoluteURL else {
            print(tmdbURLComponents)
            return
        }
        getDecodedDataFromURLSession(url: url, FromSnakeKeys: false, as: MoviesResponse.self) { recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
            }
        }
    }
    
//MARK: People by name
// https://api.themoviedb.org/3/search/person?api_key=25c6029c1f7c22b43349255ec73021e9&query=tom holland&page=1
    public func searchPeopleByName(name: String, page: Int, completion: @escaping(Result<PeoplesResponse, Error>) ->()) {
        tmdbURLComponents.path = "/3/search/person"
        tmdbURLComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "query", value: name),
            URLQueryItem(name: "page", value: String(page))
        ]
        guard let url = tmdbURLComponents.url?.absoluteURL else {
            print(tmdbURLComponents)
            return
        }
        getDecodedDataFromURLSession(url: url, FromSnakeKeys: false, as: PeoplesResponse.self) { recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
            }
        }
    }
    
// MARK: Movies for keywords
//    https://api.themoviedb.org/3/search/keyword?api_key=\(apiKey)&query=name&page=1
    public func searchForKeywords(page: Int, quearyName: String,completion: @escaping(_ result: Result<KeywordsResponse, Error>) -> ()) {
        guard page > 1 else {
            return
        }
        let url = URL(string: "https://api.themoviedb.org/3/search/keyword?api_key=\(apiKey)&query=\(quearyName)&page=\(page)")!
        getDecodedDataFromURLSession(url: url, FromSnakeKeys: false, as: KeywordsResponse.self) { recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
            }
        }
    }
    
// MARK: Movie by person √
//    https://api.themoviedb.org/3/person/\(personId)/movie_credits?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-US
    public func getMoviesByPerson(personId: Int, completion: @escaping(_ result: Result<MoviesResponse, Error>) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/person/\(personId)/movie_credits?api_key=\(apiKey)&language=en-US")!
        self.getDecodedDataFromURLSession(url: url, FromSnakeKeys: false, as: MoviesResponse.self) { recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
            }
        }
    }
}
