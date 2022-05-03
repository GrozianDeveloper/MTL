//
//  DescriptionViewController+CoreData.swift
//  MTL
//
//  Created by Bogdan Grozian on 02.05.2022.
//

import CoreData

// MARK: - CoreData
extension DescriptionViewController {
    func getCurrentMovieCoreData() {
        do {
            guard let movies = try context.fetch(MovieCoreData.fetchRequest()) as? [MovieCoreData] else {
                print("meh")
                return
            }
            movies.forEach {
                if $0.id == movie.id {
                    currentMovieCoreData = $0
                }
            }
        } catch { print(error) }
    }

    func createMovieCoreDataItem() {
        let _ = MovieCoreData(movie: movie)
        do {
            try context.save()
        } catch { print(error, 2) }
        getCurrentMovieCoreData()
    }
    
    func deleteMovieFromCoreData() {
        guard let movie = currentMovieCoreData else { return }
        context.delete(movie)
        do { try context.save()
        } catch { print(error) }
        currentMovieCoreData = nil
    }
    
    func updateMovieStatment(toStatment statment: WatchStatments) {
        guard currentMovieCoreData != nil else { return }
        currentMovieCoreData?.watchStatmentRawValue = statment.rawValue
        do {
            try context.save()
            getCurrentMovieCoreData()
        } catch { print(error) }
        getCurrentMovieCoreData()
    }
}
