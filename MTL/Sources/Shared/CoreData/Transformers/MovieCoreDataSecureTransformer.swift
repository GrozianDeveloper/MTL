//
//  MovieCoreDataSecureTransformer.swift
//  MTL
//
//  Created by Bogdan Grozyan on 16.06.2021.
//

import CoreData

@objc(MovieCoreDataSecureTransformer)
final class MovieCoreDataSecureTransformer: NSSecureUnarchiveFromDataTransformer {
    
    static let name = NSValueTransformerName(rawValue: String(describing: MovieCoreDataSecureTransformer.self))
    
    override static var allowedTopLevelClasses: [AnyClass] {
        return [MovieCoreData.self]
    }
    
    static func register() {
        let transformer = MovieCoreDataSecureTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
