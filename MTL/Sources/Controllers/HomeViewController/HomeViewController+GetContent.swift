//
//  HomeViewController+GetContent.swift
//  MTL
//
//  Created by Bogdan Grozian on 02.05.2022.
//

import Foundation

extension HomeViewController {
    func getAllMovies() {
       DispatchQueue.main.async { [weak self] in
           guard let self = self else {
               return
           }
           if self.recommendedMovies.movies == nil {
               self.getMovies(pagination: false, type: .recommended, page: 1)
           }
           if self.nowPlayingMovies.movies == nil {
               self.getMovies(pagination: false, type: .nowPlaying, page: 1)
           }
           if self.upcomingMovies.movies == nil {
               self.getMovies(pagination: false, type: .upcoming, page: 1)
           }
           if self.popularMovies.movies == nil {
               self.getMovies(pagination: false, type: .popular, page: 1)
           }
           if self.topRatedMovies.movies == nil {
               self.getMovies(pagination: false, type: .topRated, page: 1)
           }
       }
   }

    private func getMovies(pagination: Bool, type: MovieType, page: Int) {
        dataProvider.getMovies(pagination: pagination, type: type, movieId: nil, page: page) { recivedData in
            switch recivedData {
            case .success(let result):
                let index = self.sections.firstIndex(of: type)
                switch type {
                case .recommended:
                    self.recommendedMovies.pages.currentPage = page
                    if self.recommendedMovies.movies == nil {
                        self.recommendedMovies.movies = result.results
                    }
                    self.recommendedMovies.pages.maxPages = result.totalPages!
                case .nowPlaying:
                    self.nowPlayingMovies.pages.currentPage = page
                    if self.nowPlayingMovies.movies == nil {
                        self.nowPlayingMovies.movies = result.results
                    }
                    self.nowPlayingMovies.pages.maxPages = result.totalPages!
                    
                case .upcoming:
                    self.upcomingMovies.pages.currentPage = page
                    if self.upcomingMovies.movies == nil {
                        self.upcomingMovies.movies = result.results
                    }
                    self.upcomingMovies.pages.maxPages = result.totalPages!
                    
                case .popular:
                    self.popularMovies.pages.currentPage = page
                    if self.popularMovies.movies == nil {
                        self.popularMovies.movies = result.results
                    }
                    self.popularMovies.pages.maxPages = result.totalPages!
                    
                case .topRated:
                    self.topRatedMovies.pages.currentPage = page
                    if self.topRatedMovies.movies == nil {
                        self.topRatedMovies.movies = result.results
                    }
                    
                    self.topRatedMovies.pages.maxPages = result.totalPages!
                case .similar:
                    break
                }
                DispatchQueue.main.async {
                    guard let index = index else {return} // MARK: Check
                    self.mainCollectionView.reloadSections([index])
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
