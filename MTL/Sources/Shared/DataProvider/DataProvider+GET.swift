//
//  DataProvider+Search.swift
//  MTL
//
//  Created by Bogdan Grozian on 01.05.2022.
//

import UIKit.UIImage

// MARK: - Movies:
extension DataProvider {
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

    // MARK: - Movie Description
    // https://api.themoviedb.org/3/movie/522627?api_key=25c6029c1f7c22b43349255ec73021e9&append_to_response=keywords
    func GetFullyMovieDescription(movieID id: Int, completion: @escaping(Result<DescriptionMovieResponse, Error>) ->()) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&append_to_response=keywords")!
        getDecodedDataFromURLSession(url: url, FromSnakeKeys: false, as: DescriptionMovieResponse.self) { recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
            }
        }
    }
    
    // MARK: - Movie By Person
    // https://api.themoviedb.org/3/person/\(personId)/movie_credits?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-US
    func getMoviesByPerson(personId: Int, completion: @escaping(_ result: Result<MoviesResponse, Error>) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/person/\(personId)/movie_credits?api_key=\(apiKey)&language=en-US")!
        self.getDecodedDataFromURLSession(url: url, FromSnakeKeys: false, as: MoviesResponse.self) { recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
            }
        }
    }
    
    //MARK: - Movies By Query
    // https://api.themoviedb.org/3/search/movie?api_key=25c6029c1f7c22b43349255ec73021e9&query=IronCan&page=1
    func searchByQuery(quere: String, page: Int, completion: @escaping(Result<MoviesResponse, Error>) ->()) {
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
}

// MARK: - People
extension DataProvider {
    // MARK: - By Name
    // https://api.themoviedb.org/3/search/person?api_key=25c6029c1f7c22b43349255ec73021e9&query=tom holland&page=1
    func searchPeopleByName(name: String, page: Int, completion: @escaping(Result<PeoplesResponse, Error>) ->()) {
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
    
    // MARK: - Popular People
    // https://api.themoviedb.org/3/person/popular?api_key=\(apiKey)&page=\(page)
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

// MARK: - Cast
extension DataProvider {
    //    https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)
    func getMovieCast(id: Int, completion: @escaping(_ result: Result<MovieTeamResponse, Error>) -> ()) {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)")!
        self.getDecodedDataFromURLSession(url: url, FromSnakeKeys: false, as: MovieTeamResponse.self) { recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
            }
        }
    }
}

// MARK: - Person IDs
extension DataProvider {
    //    https://api.themoviedb.org/3/person/\(id)/external_ids?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-Us
    func getPersonExternalIDs(id: Int, completion: @escaping(_ result: Result<PersonExternalIDsResponse, Error>) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/person/\(id)/external_ids?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-Us")!
        self.getDecodedDataFromURLSession(url: url, FromSnakeKeys: false, as: PersonExternalIDsResponse.self) { recivedData in
            DispatchQueue.main.async {
                completion(recivedData)
            }
        }
    }
}

// MARK: - Image From URL
extension DataProvider {
    func getImageWithCaching(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let chachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(chachedImage)
        } else {
            let imageQueue = DispatchQueue(label: "com.MTL.gettingImage")
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
}
