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
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCoreData> {
        return NSFetchRequest<MovieCoreData>(entityName: "MovieCoreData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var posterImageData: Data?
    @NSManaged public var releaseDate: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var watchStatmentRawValue: Int32

}

extension MovieCoreData: Identifiable {

}
