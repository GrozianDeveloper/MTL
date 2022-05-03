//
//  TableViewCellForMoviePosterCollectionView.swift
//  MTL
//
//  Created by Bogdan Grozyan on 26.04.2021.
//

import UIKit

final class MoviePosterCollectionViewCellWithCollectionView: UICollectionViewCell {
    
    static let identifier = "MoviePosterCollectionViewCellWithCollectionView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 15
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterCollectionViewCell.nib, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionView
    }()
    
    enum scrollDirection {
        case up
        case down
    }
    
    private var previousPosition: CGFloat?
    private var currentDirection: scrollDirection = .up
    private var upCheckingScrollIndex = 0 // if index > 40 { start callback }
    private var downCheckingScrollIndex = 0 // if index > 40 { start callback }
    
    var moviePosterCellCallBack: ((_ movie: Movie) -> ())?
    
    var scrollDirectionCallBack: ((_ direction: scrollDirection) -> ())?
    
    var dataProviderCallBack: ((_ dataProvider: DataProvider) -> ())?
    
    var dataProvider = DataProvider.shared
//        didSet {
//            guard movieData.movies != nil else {return}
//            let _ = movieData.movies?.enumerated().map({ movie in
//                dataProvider.wantAndWatchedMovies.enumerated().map({ WantAndWachedMovie in
//                    if WantAndWachedMovie.element.movie.id == movie.element.id {
//                        self.movieData.movies![movie.offset] = dataProvider.wantAndWatchedMovies[WantAndWachedMovie.offset].movie
//                    }
//                })
//            })
//        }
    
    private var movieData = MoviesData()
    
    var isCollectionViewInWantWatchedVC = false
    
    func configure(with moviesData: MoviesData, dataProvider: DataProvider) {
        if moviesData.movies != nil {
            movieData.movies = (moviesData.movies?.compactMap( { $0 }).sorted(by: { $0.popularity! > $1.popularity!}))
        }
        self.dataProvider = dataProvider
        
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUIFrames()
    }
    
    private func addUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)
    }
    
    private func setupUIFrames() {
        collectionView.frame = contentView.bounds
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDataSource
extension MoviePosterCollectionViewCellWithCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
        cell.configure(with: movieData.movies?[indexPath.row], isCellInWantWatchedVC: isCollectionViewInWantWatchedVC)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.movies?.count ?? 20
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoviePosterCollectionViewCellWithCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (contentView.frame.width - 20) / 2.1
        let cellWidth: CGFloat = (width < 180 * 2 + 25) ? width : 180
        return CGSize(width: cellWidth, height: cellWidth * 1.33)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard movieData.movies != nil,
              let url = movieData.movies?[indexPath.row].posterImageURL else {
            return
        }
        dataProvider.getImageWithCaching(url: url) { [weak self] image in
            guard let self = self else {
                return
            }
            self.movieData.movies?[indexPath.row].posterImage = image
            self.moviePosterCellCallBack?(self.movieData.movies![indexPath.row])
        }
    }
    
    override func prepareForReuse() {
        guard movieData.movies?.count ?? 20 > 0 else {return}
        collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        startScrollCallBack(with: .up)
        print("scrolled")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkIsNeededToFetchMoveMovies(scrollView: scrollView)
        checkScrollDirection(scrollView: scrollView)
    }
    
    private func checkIsNeededToFetchMoveMovies(scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let offsetToStartPagiging = collectionView.contentSize.height - 1200 - scrollView.frame.size.height
        if position > offsetToStartPagiging {
            fetchMoreMovies()
        }
    }
    
    private func checkScrollDirection(scrollView: UIScrollView) {
        let currentPosition = scrollView.contentOffset.y
        if currentPosition < 10 {
            startScrollCallBack(with: .up)
        } else {
            if currentPosition > previousPosition ?? 0 {
                downCheckingScrollIndex += 1
                upCheckingScrollIndex = 0
                if downCheckingScrollIndex > 40 {
                    downCheckingScrollIndex = 0
                    startScrollCallBack(with: .down)
                }
            } else {
                downCheckingScrollIndex = 0
                upCheckingScrollIndex += 1
                if upCheckingScrollIndex > 40 {
                    upCheckingScrollIndex = 0
                    startScrollCallBack(with: .up)
                }
            }
        }
        previousPosition = currentPosition
    }
    
    private func startScrollCallBack(with direction: scrollDirection) {
        if currentDirection != direction {
            currentDirection = direction
            scrollDirectionCallBack?(direction)
        }
    }
       
    private func fetchMoreMovies() {
        guard !dataProvider.isPaginating else {
            return
        }
        guard movieData.pages.currentPage < movieData.pages.maxPages else {
            return
        }
        guard movieData.type != nil else {
            return
        }
        switch movieData.type {
        case .recommended: // Because somthing with queryItem "page"
            guard movieData.pages.currentPage < 2 else { return }
            fetchMoreMoviesComponent(type: .similar)
        default:
            fetchMoreMoviesComponent(type: movieData.type!)
        }
    }
    
    private func fetchMoreMoviesComponent(type: MovieType) {
        dataProvider.getMovies(pagination: true, type: type, movieId: nil, page: movieData.pages.currentPage + 1) { recivedData in
            switch recivedData {
            case .success(let result):
                self.movieData.pages.currentPage += 1
                if self.movieData.movies != nil {
                    var movies = result.results!.compactMap{$0}
                    movies = movies.sorted(by: {$0.popularity! > $1.popularity!})
                    self.movieData.movies!.append(contentsOf: movies)
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - CallBacks
extension MoviePosterCollectionViewCellWithCollectionView {
    private func updateDataProviderImageCache(_ movie: Movie) {
        dataProvider.imageCache.setObject(movie.posterImage!, forKey: (movie.posterImageURL ?? URL(string: "posterWithoutImage"))!.absoluteString as NSString)
        dataProviderCallBack?(dataProvider)
    }
}
