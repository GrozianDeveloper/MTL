//
//  Data Extension.swift
//  MTL
//
//  Created by Bogdan Grozyan on 10.05.2021.
//

import Foundation

extension Data {
    func decoded<T: Decodable>(as type: T.Type, strategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, completion: @escaping ( Result<T,Error>) -> ()) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = strategy
        DispatchQueue(label: "com.MTL.decoding").async {
            let result = Result {
                try decoder.decode(T.self, from: self)
            }
            completion(result)
        }
    }
}
