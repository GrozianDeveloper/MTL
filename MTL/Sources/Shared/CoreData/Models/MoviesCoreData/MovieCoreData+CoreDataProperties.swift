//
//  MovieCoreData+CoreDataProperties.swift
//  MTL
//
//  Created by Bogdan Grozyan on 16.06.2021.
//
//

import Foundation
import CoreData


extension MovieCoreData {
    @nonobjc class func fetchRequest() -> NSFetchRequest<MovieCoreData> {
        return NSFetchRequest<MovieCoreData>(entityName: "MovieCoreData")
    }

    @NSManaged var id: Int64
    @NSManaged var name: String?
    @NSManaged var overview: String?
    @NSManaged var popularity: Double
    @NSManaged var posterImageData: Data?
    @NSManaged var releaseDate: String?
    @NSManaged var voteAverage: Double
    @NSManaged var watchStatmentRawValue: Int32

}

extension MovieCoreData: Identifiable {

}
