//
//  SearchViewController.swift
//  MTL
//
//  Created by Bogdan Grozyan on 28.05.2021.
//

import UIKit

class SearchViewController: UIViewController {
    public init() {
        self.isNowSearching = false
        super.init(nibName: "SearchViewController", bundle: nil)
        onceInWeekGetData()
    }
    
    public init(SearchByGenre genre: Genre) {
        self.isNowSearching = false
        super.init(nibName: "SearchViewController", bundle: nil)
        searchByGenre(genre: genre, page: 1)
    }
    
    public init(SearchByKeyword keyword: Keyword) {
        self.isNowSearching = true
        super.init(nibName: "SearchViewController", bundle: nil)
        searchByKeyword(keyword: keyword, page: 1)
    }
    
    required init?(coder: NSCoder) {
        self.isNowSearching = false
        super.init(nibName: "SearchViewController", bundle: nil)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    public var dataProvider = DataProvider.shared
    
    private var sections: [sectionType] = [.movies, .genres, .keywords, .people]
    
    private var wantedAndWatchedMoviesID: [Int] = {
        return [1726, 27205, 99861 /* best voice i have ever heard */, 440472, 218, 339403]
    }()
    
    private var isNowSearching: Bool {
        didSet {
            if !isNowSearching {
                searchBar.placeholder = "Search"
                filteredMovies = suggestedMovies
                filteredKeywords = dataProvider.allKeywords
                filteredPeople = popularPeople
                sections = [.movies, .genres, .keywords, .people]
            }
        }
    }
    // for scroll to item when !isNowSearching
    private var lastVisibleSuggestedMovieCellIndex: IndexPath = [0, 13]
    private var lastVisibleAllKeywordCellIndex: IndexPath = [2, 30]
    private var lastVisiblePopularPeopleCellIndex: IndexPath = [0, 13]
    
    // filtered will Presented
    // others will store data while searching
    
    private var filteredMovies: [Movie]?
    private var suggestedMovies = [Movie]()
    
    private lazy var allGenres = dataProvider.allGenres
    
    private lazy var filteredKeywords: [Keyword]? = dataProvider.allKeywords
    
    private var popularPeople = [Person]()
    private var filteredPeople: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RelatedMoviePosterTableViewCellWithCollectionView.self, forCellReuseIdentifier: RelatedMoviePosterTableViewCellWithCollectionView.identifier)
        tableView.register(GenresTableViewCellWithCollectionView.self, forCellReuseIdentifier: GenresTableViewCellWithCollectionView.identifier)
        tableView.register(KeywordsTableViewCellWithCollectionView.self, forCellReuseIdentifier: KeywordsTableViewCellWithCollectionView.identifier)
        tableView.register(TeamTableViewCellWithCollectionView.self, forCellReuseIdentifier: TeamTableViewCellWithCollectionView.identifier)
        tableView.register(SectionTitleTableViewHeader.nib(), forHeaderFooterViewReuseIdentifier: SectionTitleTableViewHeader.identifier)
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        
        hideKeyboardWhenTappedAround()
    }
    
    private func onceInWeekGetData() {
        for movieId in wantedAndWatchedMoviesID {
            dataProvider.getMovies(pagination: false, type: .recommended, movieId: movieId, page: 1) { [weak self] recivedData in
                guard let self = self else { return }
                switch recivedData {
                case .success(let movies):
                    guard var movies = movies.results else { return }
                    movies = movies.filter { $0.popularity != nil }
                    movies.sort { $0.popularity! > $1.popularity! }
                    
                    self.suggestedMovies.append(contentsOf: movies)
                    self.suggestedMovies = self.suggestedMovies.removeDuplicated()
                    if !self.isNowSearching {
                        self.filteredMovies = self.suggestedMovies
                    }
                    UIView.performWithoutAnimation { [weak self] in
                        self?.tableView.reloadSections([0], with: .none)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        for page in 1...4 {
            getPopularPeople(page: page)
        }
        // Safe to offline storage
    }
    
    private func getPopularPeople(page: Int) {
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
    
    private var searchText: String = ""
}

// MARK: - Search Requests
extension SearchViewController {
    private func searchMovieByQuery(text: String, page: Int) {
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
    
    private func searchPeopleByName(text: String, page: Int) {
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
    private func searchByGenre(genre: Genre, page: Int) {
        print("search by genre not implemented")
    }
    
    private func searchByKeyword(keyword: Keyword, page: Int) {
        print("search by keyword not implemented")
    }
}

// MARK: - UITableViewDataSource
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

// MARK: - UITableViewDelegate
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

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        sections = []
        if searchText != "" {
            isNowSearching = true
            tableView.reloadData()
            searchMovieByQuery(text: searchText, page: 1)
            searchPeopleByName(text: searchText, page: 1)
        } else {
            isNowSearching = false
            tableView.reloadData()
        }
//        if searchText == "" {
//            tableView.scrollToRow(at: lastVisibleSuggestedMovieCellIndex, at: .middle, animated: true)
//            tableView.scrollToRow(at: lastVisibleAllKeywordCellIndex, at: .middle, animated: true)
//            tableView.scrollToRow(at: lastVisiblePopularPeopleCellIndex, at: .middle, animated: true)
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isNowSearching = false
        tableView.reloadData()
        dismissKeyboard()
    }
    
    @objc private func dismissKeyboard() {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isNowSearching = true
        searchBar.showsCancelButton = true
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
