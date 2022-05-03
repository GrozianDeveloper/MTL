//
//  SearchViewController+Search.swift
//  MTL
//
//  Created by Bogdan Grozian on 01.05.2022.
//

import UIKit

extension SearchViewController {
    func getPopularPeople(page: Int) {
        dataProvider.getPopularPeople(page: page) { [weak self] recivedData in
            guard let self = self else { return }
            switch recivedData {
            case .success(let result):
                guard let people = result.people else {
                    return
                }
                self.popularPeople.append(contentsOf: people)
                if !self.isNowSearching {
                    self.filteredPeople = self.popularPeople
                }
                UIView.performWithoutAnimation { [weak self] in
                    self?.tableView.reloadSections([3], with: .none)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchMovieByQuery(text: String, page: Int) {
        dataProvider.searchByQuery(quere: text, page: 1) { [weak self] in
            guard let self = self, self.isNowSearching, !self.sections.contains(.movies) else {return}
            switch $0 {
            case .success(let result):
                self.sections.append(.movies)
                self.sections.sort(by: {$0.sectionOrder < $1.sectionOrder})
                self.filteredMovies = result.results
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchPeopleByName(text: String, page: Int) {
        dataProvider.searchPeopleByName(name: text, page: page) { [weak self] in
            guard let self = self, self.isNowSearching, !self.sections.contains(.people) else {return}
            switch $0 {
            case .success(let response):
                self.sections.append(.people)
                self.sections.sort(by: {$0.sectionOrder < $1.sectionOrder})
                self.filteredPeople = response.people
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    func searchByGenre(genre: Genre, page: Int) {
        print("search by genre not implemented")
    }
    
    func searchByKeyword(keyword: Keyword, page: Int) {
        print("search by keyword not implemented")
    }
}
