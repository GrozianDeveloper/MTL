//
//  NetworkManager.swift
//  MTL
//
//  Created by Bogdan Grozyan on 24.04.2021.
//

import Network
import UIKit

final class DataProvider {
    static var shared = DataProvider(apiKey: "25c6029c1f7c22b43349255ec73021e9")
    
    private init(apiKey: String) {
        self.apiKey = apiKey
        setupGenresAndKeywords()
    }
    let apiKey: String
    
    var isPaginating = false
    
    var tmdbURLComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        return urlComponents
    }()
    
    var imageCache = NSCache<NSString, UIImage>()
    
    private(set) var allGenres: [Genre] = []
    private(set) var allKeywords: [Keyword] = []
}

// MARK: Check Internet Connection
extension DataProvider {
    static func checkForInternetConnection(completion: @escaping(Bool) -> ()) {
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
}

// MARK: - Setup
private extension DataProvider {
    private func setupGenresAndKeywords() {
        func readAndDecode<T: Decodable>(as: T.Type, name: String, completion: @escaping ((T) -> ())) {
            let path = Bundle.main.path(forResource: name, ofType: "json")!
            let string = try! String(contentsOfFile: path).data(using: .utf8)
            string?.decoded(as: T.self, completion: { result in
                switch result {
                case .success(let T):
                    completion(T)
                case .failure(let error):
                    print(error)
                }
            })
        }
        readAndDecode(as: [Genre].self, name: "AllGenres") { [weak self] genres in
            self?.allGenres = genres
        }
        readAndDecode(as: [Keyword].self, name: "AllKeywords") { [weak self] keywords in
            self?.allKeywords = keywords
        }
    }
}
