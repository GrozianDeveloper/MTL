//
//  SearchViewController+TableView.swift
//  MTL
//
//  Created by Bogdan Grozian on 03.05.2022.
//

import UIKit

// MARK: - Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .movies:
            return 220
        case .genres:
            return 86
        case .keywords:
            return 122
        case .people:
            return 160
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionTitleTableViewHeader.identifier) as! SectionTitleTableViewHeader
        let HeaderTitle = sections[section].sectionTitle
        header.titleLabel.text = HeaderTitle
        return header
    }
}

// MARK: - DataSource
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .movies:
            let cell = tableView.dequeueReusableCell(withIdentifier: RelatedMoviePosterTableViewCellWithCollectionView.identifier, for: indexPath) as! RelatedMoviePosterTableViewCellWithCollectionView
            cell.configure(with: filteredMovies)
            cell.movieCellCallBack = movieCellSelected(movie:)
            return cell
        case .genres:
            let cell = tableView.dequeueReusableCell(withIdentifier: GenresTableViewCellWithCollectionView.identifier, for: indexPath) as! GenresTableViewCellWithCollectionView
            cell.configure(with: allGenres)
            cell.genreCellCallBack = genreCellSelected(genre:)
            return cell
        case .keywords:
            let cell = tableView.dequeueReusableCell(withIdentifier: KeywordsTableViewCellWithCollectionView.identifier, for: indexPath) as! KeywordsTableViewCellWithCollectionView
            cell.configure(with: filteredKeywords)
            cell.keywordCellCallBack = keywordCellSelected(keyword:)
            return cell
        case .people:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamTableViewCellWithCollectionView.identifier, for: indexPath) as! TeamTableViewCellWithCollectionView
            cell.configure(with: filteredPeople)
            cell.castCellCallBack = peopleCellSelected(person:)
            return cell
        }
    }
}

// MARK: - CallBacks
extension SearchViewController {
    private func movieCellSelected(movie: Movie) {
        let vc = DescriptionViewController(movie: movie)
        present(vc, animated: true, completion: nil)
    }
    
    private func genreCellSelected(genre: Genre) {
        print("Gengre", genre)
    }

    private func keywordCellSelected(keyword: Keyword) {
        print("Keyword", keyword)
    }
    
    private func peopleCellSelected(person: Person) {
        DispatchQueue.main.async { [weak self] in
            guard let personID = person.id, let self = self else {
                return
            }
            let personVC = PersonViewController(person: person)
            self.dataProvider.getMoviesByPerson(personId: personID) { recivedData in
                switch recivedData {
                case .success(let results):
                    personVC.configureMovies(with: results)
                case .failure(let error):
                    print(error)
                }
            }
            self.dataProvider.getPersonExternalIDs(id: personID) { recivedData in
                switch recivedData {
                case .success(let result):
                    personVC.configurePersonExternalIDs(with: result)
                case .failure(let error):
                    print(error)
                }
            }
            self.present(personVC, animated: true, completion: nil)
        }
    }
}
