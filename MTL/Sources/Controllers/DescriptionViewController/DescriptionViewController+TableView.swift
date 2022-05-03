//
//  DescriptionViewController+TableView.swift
//  MTL
//
//  Created by Bogdan Grozian on 02.05.2022.
//

import UIKit
import SafariServices.SFSafariViewController

// MARK: - DataSource
extension DescriptionViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .movieStatments: // 0
            let cell = tableView.dequeueReusableCell(withIdentifier: StatementsTableViewCell.identifier) as! StatementsTableViewCell
            cell.configure(with: movieStatment, movieId: self.movie.id)
            cell.changeStatmentCallBack = changeMovieStatment(_:)
            cell.pushAlertToChangeStatmentCallBack = changeWatchedStatmentToStatmentCreateAlert
            return cell
        case .votePopularity: // 1
            let cell = tableView.dequeueReusableCell(withIdentifier: VotePopularityRuntimeTableViewCell.identifier, for: indexPath) as! VotePopularityRuntimeTableViewCell
            cell.configure(with: movie.voteAverage, popularity: movie.popularity)
            return cell
        case .watchOnline: // 2
            let cell = tableView.dequeueReusableCell(withIdentifier: OnlineActivityTableViewCell.identifier, for: indexPath) as! OnlineActivityTableViewCell
            cell.configure(cellType: .watchOnline("See on IMDB"))
            return cell
        case .sentToFriend: // 3
            let cell = tableView.dequeueReusableCell(withIdentifier: OnlineActivityTableViewCell.identifier, for: indexPath) as! OnlineActivityTableViewCell
            cell.configure(cellType: .sendToAFriend)
            return cell
        case .overview: // 4
            let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier, for: indexPath) as! OverviewTableViewCell
            cell.configure(with: movie.overview)
            return cell
        case .genres: // 5
            let cell = tableView.dequeueReusableCell(withIdentifier: GenresTableViewCellWithCollectionView.identifier, for: indexPath) as! GenresTableViewCellWithCollectionView
            cell.configure(with: movieDescripthion?.genres)
            cell.genreCellCallBack = genreCellSelected(genre:)
            return cell
        case .keywords: // 6
            let cell = tableView.dequeueReusableCell(withIdentifier: KeywordsTableViewCellWithCollectionView.identifier, for: indexPath) as! KeywordsTableViewCellWithCollectionView
            cell.configure(with: movieDescripthion?.keywords)
            cell.keywordCellCallBack = keywordCellSelected(keyword:)
            return cell
        case .team: // 7
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamTableViewCellWithCollectionView.identifier, for: indexPath) as! TeamTableViewCellWithCollectionView
            cell.configure(with: movieTeam)
            cell.castCellCallBack = castCellSelected(person:)
            return cell
        case .relatedMovies: // 8
            let cell = tableView.dequeueReusableCell(withIdentifier: RelatedMoviePosterTableViewCellWithCollectionView.identifier, for: indexPath) as! RelatedMoviePosterTableViewCellWithCollectionView
            cell.configure(with: relatedMovies)
            cell.movieCellCallBack = movieCellSelected(movie:)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension DescriptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        switch section {
        case .watchOnline, .sentToFriend:
            return 35
        case .votePopularity, .movieStatments:
            return 60
        case .overview:
            return UITableView.automaticDimension
        case .genres:
            return 41
        case .keywords:
            return 81
        case .team:
            return 160
        case .relatedMovies:
            return 220
        }
    }
    
    // MARK: Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { // Header before genre
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DescriptionTableViewHeader.identifier) as! DescriptionTableViewHeader
            header.configure(movie: movie)
            return header
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionTitleTableViewHeader.identifier) as! SectionTitleTableViewHeader
        let HeaderTitle = sections[section].HeaderTitle
        header.titleLabel.text = HeaderTitle
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = sections[section]
        switch sectionType {
        case .movieStatments: // Poster
            return 470
        case .votePopularity, .watchOnline, .sentToFriend: // Not needed
            return 0
        default:
            return 30
        }
    }
    
    // MARK: Cell selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            switch self?.sections[indexPath.section] {
            case .watchOnline:
                if let url = self?.imdbURL {
                    self?.presentSafariViewController(url: url)
                } else {
                    self?.lastOnlineActivityCellThatWasTapped = .watchOnline
                    self?.activityIndicator.startAnimating()
                }
            case .sentToFriend:
                if let url = self?.imdbURL {
                    self?.shareContent(items: [url])
                    tableView.deselectRow(at: [3, 0], animated: true)
                } else {
                    self?.lastOnlineActivityCellThatWasTapped = .sentToFriend
                    self?.activityIndicator.startAnimating()
                }
            default:
                break
            }
        }
    }
    
    func presentSafariViewController(url: URL) {
        self.tableView.deselectRow(at: [2, 0], animated: true)
        let vc = SFSafariViewController.init(url: url)
        self.present(vc, animated: true, completion: nil)
    }
    
    func shareContent(items: [Any]) {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch sections[indexPath.section] {
        case .watchOnline, .sentToFriend:
            return true
        default:
            return false
        }
    }
}

extension DescriptionViewController {
    private func changeMovieStatment(_ statment: WatchStatments) -> () {
        movieStatment = statment
    }
    private func genreCellSelected(genre: Genre) {
        let vc = SearchViewController(SearchByGenre: genre)
        present(vc, animated: true, completion: nil)
    }

    private func keywordCellSelected(keyword: Keyword) {
        let vc = SearchViewController(SearchByKeyword: keyword)
        present(vc, animated: true, completion: nil)
    }
    
    private func movieCellSelected(movie: Movie) {
        let vc = DescriptionViewController(movie: movie)
        present(vc, animated: true, completion: nil)
    }
    
    private func changeWatchedStatmentToStatmentCreateAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let removeFromWatchedAction = UIAlertAction(title: "Remove from Watched", style: .destructive) { _ in
            self.movieStatment = .none
        }
        let moveToWantAction = UIAlertAction(title: "Move to Want", style: .default) { _ in
            self.movieStatment = .wanted
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(removeFromWatchedAction)
        alertController.addAction(moveToWantAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func castCellSelected(person: Person) {
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
