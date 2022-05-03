//
//  DescriptionViewController.swift
//  MTL
//
//  Created by Bogdan Grozyan on 27.04.2021.
//  Recreated by Bogdan Grozyan on 08.05.2021.
//

import UIKit
import CoreData
import SafariServices

fileprivate extension DescriptionViewController {
    private enum sectionType {
        case movieStatments
        case votePopularity
        case watchOnline
        case sentToFriend
        case genres
        case keywords
        case overview
        case team
        case relatedMovies
        var HeaderTitle: String {
            switch self {
            case .genres: return "Genres"
            case .keywords: return "Keywords"
            case .overview: return "Sinopsis"
            case .team: return "Cast & Crew"
            case .relatedMovies: return "Related Movies"
            default:
                return "" // This message will never happend
            }
        }
    }
}

final class DescriptionViewController: UIViewController {
    public init(movie: Movie) {
        self.movieStatment = movie.watchStatment
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
        self.getMovieData()
    }
    
    public init(movie: MovieCoreData) {
        self.movie = Movie(movieCoreData: movie)
        self.movieStatment = self.movie.watchStatment
        super.init(nibName: nil, bundle: nil)
        self.getMovieData()
    }
    
    required init?(coder: NSCoder) {
        print("Where the movie?")
        self.movieStatment = .none
        self.movie = Movie()
        super.init(nibName: nil, bundle: nil)
    }
    
    public var movieStatment: WatchStatments {
        didSet {
            movie.watchStatment = movieStatment
            if movieStatment != .none {
                (currentMovieCoreData != nil) ? updateMovieStatment(toStatment: movieStatment):  createMovieCoreDataItem()
            } else {
                deleteMovieFromCoreData()
            }
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.reloadSections([0], with: .none)
            }
        }
    }
    
    private enum OnlineActivityCell{
        case watchOnline
        case sentToFriend
    }
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var currentMovieCoreData: MovieCoreData?
    
    private var lastOnlineActivityCellThatWasTapped: OnlineActivityCell = .sentToFriend
    private var imdbURL: URL?
    private var dataProvider = DataProvider.shared
    
    private var movie: Movie
    
    private var movieTeam: [Person]?
    private var relatedMovies: [Movie]?
    private var movieDescripthion: DescriptionMovieResponse?
    
    private var personDescription = [Person]()
    private var personIDs = [PersonExternalIDsResponse]()
    
    // 0 1 2 3 4 5 6 7 8
    private var sections: [sectionType] = [.movieStatments, .votePopularity, .watchOnline, .sentToFriend, .overview, .genres, .keywords, .team, .relatedMovies]
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(DescriptionTableViewHeader.nib(), forHeaderFooterViewReuseIdentifier: DescriptionTableViewHeader.identifier) // Poster
        tableView.register(SectionTitleTableViewHeader.nib(), forHeaderFooterViewReuseIdentifier: SectionTitleTableViewHeader.identifier) // -_-
        tableView.register(StatementsTableViewCell.nib(), forCellReuseIdentifier: StatementsTableViewCell.identifier) // MovieStatments
        tableView.register(VotePopularityRuntimeTableViewCell.nib(), forCellReuseIdentifier: VotePopularityRuntimeTableViewCell.identifier) // VotePopularityRuntime
        tableView.register(OnlineActivityTableViewCell.nib(), forCellReuseIdentifier: OnlineActivityTableViewCell.identifier) // WatchOnline and SentToFriend
        tableView.register(OverviewTableViewCell.nib(), forCellReuseIdentifier: OverviewTableViewCell.identifier) // Overview
        tableView.register(GenresTableViewCellWithCollectionView.self, forCellReuseIdentifier: GenresTableViewCellWithCollectionView.identifier) // Genres
        tableView.register(KeywordsTableViewCellWithCollectionView.self, forCellReuseIdentifier: KeywordsTableViewCellWithCollectionView.identifier)
        tableView.register(TeamTableViewCellWithCollectionView.self, forCellReuseIdentifier: TeamTableViewCellWithCollectionView.identifier) // Team
        tableView.register(RelatedMoviePosterTableViewCellWithCollectionView.self, forCellReuseIdentifier: RelatedMoviePosterTableViewCellWithCollectionView.identifier) // RelatedMovies
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 30
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        indicator.layer.zPosition = 1
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrames()
    }
}

// MARK: - CoreData
fileprivate extension DescriptionViewController {
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

// MARK: - UITableViewDataSource
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
    
    private func presentSafariViewController(url: URL) {
        self.tableView.deselectRow(at: [2, 0], animated: true)
        let vc = SFSafariViewController.init(url: url)
        self.present(vc, animated: true, completion: nil)
    }
    
    private func shareContent(items: [Any]) {
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

// MARK: CallBacks
extension DescriptionViewController {
    private func changeMovieStatment(_ statment: WatchStatments) -> () {
        movieStatment = statment
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
    
    private func movieCellSelected(movie: Movie) {
        let vc = DescriptionViewController(movie: movie)
        present(vc, animated: true, completion: nil)
    }

    private func genreCellSelected(genre: Genre) {
        let vc = SearchViewController(SearchByGenre: genre)
        present(vc, animated: true, completion: nil)
    }

    private func keywordCellSelected(keyword: Keyword) {
        let vc = SearchViewController(SearchByKeyword: keyword)
        present(vc, animated: true, completion: nil)
    }

}

// MARK: Setup methods
fileprivate extension DescriptionViewController {
    private func getMovieData() {
        if movie.posterImage == nil, let url = movie.posterImageURL {
            dataProvider.getImageWithCaching(url: url) { [weak self] image in
                self?.movie.posterImage = image
                UIView.performWithoutAnimation { [weak self] in
                    self?.tableView.reloadSections([0], with: .none)
                }
            }
        }
        dataProvider.GetFullyMovieDescription(movieID: self.movie.id) { [weak self] recivedData in
            guard let self = self else {
                return
            }
            switch recivedData {
            case .success(let result):
                self.movieDescripthion = result
                if let imdb = self.movieDescripthion?.imdb {
                    self.imdbURL = URL(string: "https://www.imdb.com/title/\(imdb)/")
                    if self.activityIndicator.isAnimating {
                        switch self.lastOnlineActivityCellThatWasTapped {
                        case .watchOnline:
                            self.presentSafariViewController(url: self.imdbURL!)
                        case .sentToFriend:
                            self.shareContent(items: [self.imdbURL!])
                            self.tableView.deselectRow(at: [3, 0], animated: true)
                        }
                    }
                    self.activityIndicator.stopAnimating()
                    UIView.performWithoutAnimation { [weak self] in
                        self?.tableView.reloadSections([5], with: .none) // Genres
                        self?.tableView.reloadSections([6], with: .none) // Keywords
                    }
                } else {
                    self.sections.remove(at: 6)
                    self.sections.remove(at: 5)
                    self.sections.remove(at: 3)
                    self.sections.remove(at: 2)
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print("error", error)
            }
        }
        dataProvider.getMovieCast(id: self.movie.id) { [weak self] recivedData in
            switch recivedData {
            case .success(let result):
                guard let self = self else {
                    return
                }
                self.movieTeam = result.cast
                for a in 0...7 {
                    if let url = self.movieTeam?[a].profileImageURL {
                        self.dataProvider.getImageWithCaching(url: url, completion: {
                            self.movieTeam?[a].profileImage = $0
                        })
                    }
                    UIView.performWithoutAnimation { [weak self] in
                        self?.tableView.reloadSections([7], with: .none)
                    }
                }
            case .failure(let error):
                print("error", error)
            }
        }
    
        dataProvider.getMovies(pagination: false, type: .recommended, movieId: self.movie.id, page: 1) { [weak self] recivedData in
            switch recivedData {
            case .success(let result):
                guard let self = self else {
                    return
                }
            self.relatedMovies = result.results
                UIView.performWithoutAnimation { [weak self] in
                    self?.tableView.reloadSections([8], with: .none)
                }
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    
    
    private func setupViewController() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        view.addSubview(activityIndicator)
        
        getCurrentMovieCoreData()
    }
    
    private func setupFrames() {
        tableView.frame = view.bounds
        activityIndicator.frame = view.frame
    }
}
