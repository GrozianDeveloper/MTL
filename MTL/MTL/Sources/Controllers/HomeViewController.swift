//
//  HomeViewController.swift
//  MTL
//
//  Created by Bogdan Grozyan on 26.04.2021.
//

import UIKit

final class HomeViewController: UIViewController {
    private let movieTypeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieTypeCollectionViewCell.self, forCellWithReuseIdentifier: MovieTypeCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    public let mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MoviePosterCollectionViewCellWithCollectionView.self, forCellWithReuseIdentifier: MoviePosterCollectionViewCellWithCollectionView.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let goToWatchListViewControllerButton: UIButton = {
        let button = WatchListButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.blurEffectView.layer.cornerRadius = button.layer.cornerRadius
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = SearchButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 20
        button.blurEffectView.layer.cornerRadius = button.layer.cornerRadius
        return button
    }()
    
    private var searchButtonTopConstraint: NSLayoutConstraint?
    
    private var dataProvider = DataProvider.shared
    
    private var recommendedMovies: MoviesData = MoviesData(type: .recommended)
    private var nowPlayingMovies: MoviesData = MoviesData(type: .nowPlaying)
    private var topRatedMovies: MoviesData = MoviesData(type: .topRated)
    private var popularMovies: MoviesData = MoviesData(type: .popular)
    private var upcomingMovies: MoviesData = MoviesData(type: .upcoming)
    
    private var sections: [MovieType] = [.recommended, .nowPlaying, .upcoming, .popular, .topRated]
    
    private var currentHighlitedSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController() {
        setupContent()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
    }
    
    private func setupUI() {
        view.addSubview(movieTypeCollectionView)
        view.addSubview(mainCollectionView)
        view.addSubview(goToWatchListViewControllerButton)
        view.addSubview(searchButton)
        
        // searchButton
        searchButtonTopConstraint = searchButton.topAnchor.constraint(equalTo: movieTypeCollectionView.safeAreaLayoutGuide.bottomAnchor, constant: 15)
        searchButtonTopConstraint?.isActive = true
        searchButton.addTarget(self, action: #selector(presentSearchSearchViewController), for: .touchUpInside)
        
        // movieTypeCollectionView
        movieTypeCollectionView.delegate = self
        movieTypeCollectionView.dataSource = self
        
        // mainCollectionView
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        // goToWatchListViewControllerButton
        goToWatchListViewControllerButton.addTarget(self, action: #selector(presentWatchlistViewController), for: .touchUpInside)
    }
    
    private func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(movieTypeCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(movieTypeCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(movieTypeCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(movieTypeCollectionView.heightAnchor.constraint(equalToConstant: 40))
        
        constraints.append(mainCollectionView.topAnchor.constraint(equalTo: movieTypeCollectionView.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(mainCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        
        constraints.append(goToWatchListViewControllerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12))
        constraints.append(goToWatchListViewControllerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40))
        constraints.append(goToWatchListViewControllerButton.heightAnchor.constraint(equalToConstant: 48))
        constraints.append(goToWatchListViewControllerButton.widthAnchor.constraint(equalToConstant: 77))
        
        constraints.append(searchButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(searchButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5))
        constraints.append(searchButton.heightAnchor.constraint(equalToConstant: 40))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupContent() {
        DataProvider.checkingForInternetConnection { isConnected in
            if isConnected {
                self.getMovieDataFromInternet()
            } else {
                print("isConnected", isConnected)
            }
        }
    }
    
    private func getMovieDataFromInternet() {
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
    
    func getMovies(pagination: Bool, type: MovieType, page: Int) {
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
    
    @objc func presentWatchlistViewController(_ sender: UIButton) {
        let vc = WatchListViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentSearchSearchViewController(_ sender: UIButton) {
        let vc = SearchViewController()
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        highlightMovieTypeSectionAt(atSection: currentHighlitedSection)
        let movieType = sections[indexPath.section]
        var moviesData: MoviesData?
        switch movieType {
        case .recommended:
            moviesData = recommendedMovies
        case .nowPlaying:
            moviesData = nowPlayingMovies
        case .popular:
            moviesData = popularMovies
        case .upcoming:
            moviesData = upcomingMovies
        case .topRated:
            moviesData = topRatedMovies
        case .similar:
            break
        }
        
        if collectionView == movieTypeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieTypeCollectionViewCell.identifier, for: indexPath) as! MovieTypeCollectionViewCell
            cell.configure(text: movieType.title, color: nil)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCollectionViewCellWithCollectionView.identifier, for: indexPath) as! MoviePosterCollectionViewCellWithCollectionView
            
//            if moviesData?.movies != nil {
//                let _ = moviesData?.movies?.enumerated().map { movie in
//                    dataProvider.wantAndWatchedMovies.enumerated().map { movieWithstatment in
//                        if movieWithstatment.element.movie.name == movie.element.name {
//                            moviesData?.movies![movie.offset] = dataProvider.wantAndWatchedMovies[movieWithstatment.offset].movie
//                        }
//                    }
//                }
//            }
            cell.configure(with: moviesData!, dataProvider: dataProvider)
            cell.dataProviderCallBack = dataProviderCallBack(_:)
            cell.moviePosterCellCallBack = movieCellSelected(movie:)
            cell.scrollDirectionCallBack = scrollDirectionCallBack(direction:)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == movieTypeCollectionView {
            let font = UIFont.systemFont(ofSize: 25)
            let fontAttributes = [NSAttributedString.Key.font: font]
            
            let textSize = sections[indexPath.section].title.size(withAttributes: fontAttributes)
            
            return CGSize(width: textSize.width + 10, height: textSize.height)
        } else {
            return CGSize(width: mainCollectionView.frame.width, height: mainCollectionView.frame.height)
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        super.dismiss(animated: flag, completion: completion)
        mainCollectionView.reloadData()
    }
}

// MARK: - CallBacks
extension HomeViewController {
    private func dataProviderCallBack(_ dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    func movieCellSelected(movie: Movie) {
        let vc = DescriptionViewController.init(movie: movie)
        self.present(vc, animated: true, completion: nil)
    }
    
    func scrollDirectionCallBack(direction: MoviePosterCollectionViewCellWithCollectionView.scrollDirection) {
        switch direction {
        case .up:
            showSearchButton()
        case .down:
            hideSearchButton()
        }
    }
    private func showSearchButton() {
        searchButton.isHidden = false
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.searchButtonTopConstraint?.constant = 15
            self.searchButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideSearchButton() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.searchButtonTopConstraint?.constant = 0
            self.searchButton.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { self.searchButton.isHidden = $0 }
    }
}

// MARK: Highlight feature
extension HomeViewController {
    private func updateCurrentMovieTypeSection() {
        let previousHighlitedSection = currentHighlitedSection
        for cell in mainCollectionView.visibleCells {
            let section = mainCollectionView.indexPath(for: cell)!.section
            currentHighlitedSection = section
        }
        if currentHighlitedSection != previousHighlitedSection {
            showSearchButton()
        }
        unhighlightAllMovieTypeSections()
        movieTypeCollectionView.scrollToItem(at: IndexPath.init(item: 0, section: currentHighlitedSection), at: .centeredHorizontally, animated: true)
        highlightMovieTypeSectionAt(atSection: currentHighlitedSection)
    }
    
    private func highlightMovieTypeSectionAt(atSection section: Int) {
        if let cell = movieTypeCollectionView.cellForItem(at: IndexPath.init(item: 0, section: section)) as? MovieTypeCollectionViewCell {
            cell.isHighlighted = true
        }
    }
    
    private func unhighlightAllMovieTypeSections() {
        for index in 0...sections.count {
            if let cell = movieTypeCollectionView.cellForItem(at: IndexPath.init(item: 0, section: index)) as? MovieTypeCollectionViewCell {
                cell.isHighlighted = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == mainCollectionView {
            highlightMovieTypeSectionAt(atSection: currentHighlitedSection)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == movieTypeCollectionView {
            mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainCollectionView {
            for cell in mainCollectionView.visibleCells {
                let section = mainCollectionView.indexPath(for: cell)!.section
                unhighlightAllMovieTypeSections()
                highlightMovieTypeSectionAt(atSection: section)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.updateCurrentMovieTypeSection()
            }
        }
    }
}
