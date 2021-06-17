//
//  MovieCoreData+CoreDataClass.swift
//  MTL
//
//  Created by Bogdan Grozyan on 16.06.2021.
//
//

import UIKit
import CoreData

@objc(MovieCoreData)
public class MovieCoreData: NSManagedObject {
//    public static var supportsSecureCoding: Bool = true
//
//    @objc
//    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
//        super.init(entity: entity, insertInto: context)
//    }
    
    convenience init(movie: Movie) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(entity: MovieCoreData.entity(), insertInto: context)
        id = Int64(movie.id)
        name = movie.name
        releaseDate = movie.releaseDate
        watchStatmentRawValue = movie.watchStatment.rawValue
        posterImageData = movie.posterImage?.pngData()
        voteAverage = movie.voteAverage ?? 0.0
        popularity = movie.popularity ?? 0.0
        overview = movie.overview
    }

//    private enum Keys: String {
//        case id
//        case name
//        case releaseDate
//        case watchStatmentRawValue
//        case posterImage
//        case voteAverage
//        case popularity
//        case overview
//    }
//
//    public func encode(with coder: NSCoder) {
//        coder.encode(id, forKey: Keys.id.rawValue)
//        let nsName = name as NSString? ?? "name"
//        coder.encode(nsName, forKey: Keys.name.rawValue)
//        let nsDate = releaseDate as NSString?
//        coder.encode(nsDate, forKey: Keys.releaseDate.rawValue)
//        coder.encode(watchStatmentRawValue, forKey: Keys.watchStatmentRawValue.rawValue)
//        coder.encode(posterImageData, forKey: Keys.posterImage.rawValue)
//        coder.encode(voteAverage, forKey: Keys.voteAverage.rawValue)
//        coder.encode(popularity, forKey: Keys.popularity.rawValue)
//        coder.encode(overview, forKey: Keys.overview.rawValue)
//    }
//
//    public required init?(coder: NSCoder) {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        super.init(entity: MovieCoreData.entity(), insertInto: context)
//        id = coder.decodeInt64(forKey: Keys.id.rawValue)
//        name = coder.decodeObject(of: NSString.self, forKey: Keys.name.rawValue) as String?
//        releaseDate = coder.decodeObject(of: NSString.self, forKey: Keys.releaseDate.rawValue) as String?
//        watchStatmentRawValue = coder.decodeInt32(forKey: Keys.watchStatmentRawValue.rawValue)
//        posterImageData = coder.decodeObject(of: NSData.self, forKey: Keys.posterImage.rawValue) as Data?
//        voteAverage = coder.decodeDouble(forKey: Keys.voteAverage.rawValue)
//        popularity = coder.decodeDouble(forKey: Keys.popularity.rawValue)
//        overview = coder.decodeObject(of: NSString.self, forKey: Keys.overview.rawValue) as String?
//    }
}
