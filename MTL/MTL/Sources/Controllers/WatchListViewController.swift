//
//  WatchListViewController.swift
//  MTL
//
//  Created by Bogdan Grozyan on 16.05.2021.
//

import UIKit

final class WatchListViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum SectionType {
        case want
        case watched
        
        var title: String {
            switch self {
            case .want: return "Want"
            case .watched: return "Watched"
            }
        }
    }
    
    private var dataProvider = DataProvider.shared
//    {
//        didSet {
//            wantList = dataProvider.wantAndWatchedMovies.filter({ $0.movie.watchStatment == .wanted })
//            watchedList = dataProvider.wantAndWatchedMovies.filter({ $0.movie.watchStatment == .watched })
//            mainCollectionView.reloadData()
//        }
//    }
    
    public func updateDataProviderProperty(with dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    private var wantList = [MovieCoreData]()
    
    private var watchedList = [MovieCoreData]()
    
    private var sections: [SectionType] = [.want, .watched]
    
    private let listTypeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MoviePosterCollectionViewCellWithCollectionView.self, forCellWithReuseIdentifier: MoviePosterCollectionViewCellWithCollectionView.identifier)
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
    
    private var currentHighlitedSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
    }
    
    private func setupController() {
        listTypeCollectionView.delegate = self
        listTypeCollectionView.dataSource = self
        view.addSubview(listTypeCollectionView)
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        view.addSubview(mainCollectionView)
    }
    
    private func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(listTypeCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(listTypeCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(listTypeCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(listTypeCollectionView.heightAnchor.constraint(equalToConstant: 40))
        
        constraints.append(mainCollectionView.topAnchor.constraint(equalTo: listTypeCollectionView.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(mainCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }

}
// MARK: UICollectionViewDataSource
extension WatchListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        highlightMovieTypeSectionAt(atSection: currentHighlitedSection)
        let sectionType = sections[indexPath.section]
        var allMoviesData = [MovieCoreData]()
        switch sectionType {
        case .want:
            allMoviesData = wantList
        case .watched:
            allMoviesData = watchedList
        }
        if collectionView == listTypeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieTypeCollectionViewCell.identifier, for: indexPath) as! MovieTypeCollectionViewCell
            let color: UIColor = (sectionType == .want) ? .lightGray : .link
            cell.configure(text: sectionType.title, color: color)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCollectionViewCellWithCollectionView.identifier, for: indexPath) as! MoviePosterCollectionViewCellWithCollectionView
            let movies = allMoviesData.compactMap { Movie(movieCoreData: $0) }
            let movieData = MoviesData.init(
                type: nil,
                movies: movies,
                currentPage: 0,
                maxPages: 0)
            cell.isCollectionViewInWantWatchedVC = true
            cell.configure(with: movieData, dataProvider: dataProvider)
            cell.moviePosterCellCallBack = movieCellSelected(movie:)
            return cell
        }
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension WatchListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == listTypeCollectionView {
            let font = UIFont.systemFont(ofSize: 25)
            let fontAttributes = [NSAttributedString.Key.font: font]
            
            let textSize = sections[indexPath.section].title.size(withAttributes: fontAttributes)
            
            return CGSize(width: textSize.width + 10, height: textSize.height)
        } else {
            return CGSize(width: mainCollectionView.frame.width, height: mainCollectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == mainCollectionView {
            highlightMovieTypeSectionAt(atSection: currentHighlitedSection)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == listTypeCollectionView {
            mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in mainCollectionView.visibleCells {
            let section = mainCollectionView.indexPath(for: cell)!.section
            unhighlightAllMovieTypeSections()
            highlightMovieTypeSectionAt(atSection: section)
        }
        
        if scrollView == mainCollectionView {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.updateCurrentMovieTypeSection()
            }
        }
    }
    
    private func updateCurrentMovieTypeSection() {
        for cell in mainCollectionView.visibleCells {
            let section = mainCollectionView.indexPath(for: cell)!.section
            currentHighlitedSection = section
        }
        unhighlightAllMovieTypeSections()
        listTypeCollectionView.scrollToItem(at: IndexPath.init(item: 0, section: currentHighlitedSection), at: .centeredHorizontally, animated: true)
        highlightMovieTypeSectionAt(atSection: currentHighlitedSection)
    }
    
    private func highlightMovieTypeSectionAt(atSection section: Int) {
        if let cell = listTypeCollectionView.cellForItem(at: IndexPath.init(item: 0, section: section)) as? MovieTypeCollectionViewCell {
            cell.isHighlighted = true
        }
    }
    
    private func unhighlightAllMovieTypeSections() {
        for index in 0...sections.count {
            if let cell = listTypeCollectionView.cellForItem(at: IndexPath.init(item: 0, section: index)) as? MovieTypeCollectionViewCell {
                cell.isHighlighted = false
            }
        }
    }
}

// MARK: CallBacks
extension WatchListViewController {
    func movieCellSelected(movie: Movie) {
        let vc = DescriptionViewController.init(movie: movie)
        self.present(vc, animated: true, completion: nil)
    }
}
