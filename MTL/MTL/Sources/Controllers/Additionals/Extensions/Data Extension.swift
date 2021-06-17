//
//  Data Extension.swift
//  MTL
//
//  Created by Bogdan Grozyan on 10.05.2021.
//

import Foundation

extension Data {
    
    func decoded<T: Decodable>(as type: T.Type, completion: @escaping ( Result<T,Error>) -> ()) {
        let result = Result {
            try JSONDecoder().decode(T.self, from: self)
        }
        completion(result)
    }
    
    func decodedFromSnakeKeys<T: Decodable>(as type: T.Type, completion: @escaping ( Result<T,Error>) -> ()) {
        let decoder = DataProvider.jsonDecoder
        let result = Result {
            try decoder.decode(T.self, from: self)
        }
        completion(result)
    }
    
}
