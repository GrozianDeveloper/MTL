//
//  DataProvider+Support.swift
//  MTL
//
//  Created by Bogdan Grozian on 01.05.2022.
//

import Foundation

extension DataProvider {
    func getDecodedDataFromURLSession<T: Decodable>(url: URL, FromSnakeKeys: Bool, as type: T.Type, completion: @escaping( Result<T, Error>) -> ()) {
        let requestQueue = DispatchQueue(label: "com.MTL.url.requesting")
        requestQueue.async {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
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
                let strategy: JSONDecoder.KeyDecodingStrategy = FromSnakeKeys ? .convertFromSnakeCase : .useDefaultKeys
                data.decoded(as: T.self, strategy: strategy, completion: completion)
            }
            dataTask.resume()
        }
    }
}

// MARK: - Models
extension DataProvider {
    enum RequestErrors: Error {
        case dataStructureError
        case somethingWithResponse
        case paginatingAlreadyInRun
    }
}
