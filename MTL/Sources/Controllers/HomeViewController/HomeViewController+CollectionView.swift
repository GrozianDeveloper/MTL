//
//  HomeViewController+CollectionView.swift
//  MTL
//
//  Created by Bogdan Grozian on 02.05.2022.
//

import UIKit

// MARK: - Delegate
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

// MARK: - DataSource
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
        let cell: UICollectionViewCell
        if collectionView == movieTypeCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieTypeCollectionViewCell.identifier, for: indexPath)
            let cell = cell as! MovieTypeCollectionViewCell
            cell.configure(text: movieType.title, color: nil)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCollectionViewCellWithCollectionView.identifier, for: indexPath)
            let cell = cell as! MoviePosterCollectionViewCellWithCollectionView
            cell.configure(with: moviesData!, dataProvider: dataProvider)
            cell.dataProviderCallBack = dataProviderCallBack(_:)
            cell.moviePosterCellCallBack = movieCellSelected(movie:)
            cell.scrollDirectionCallBack = scrollDirectionCallBack(direction:)
        }
        return cell
    }
}

// MARK: - Highlight Feature
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
}

// MARK: - Support
extension HomeViewController {
    private func dataProviderCallBack(_ dataProvider: DataProvider) {
        self.dataProvider = dataProvider
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
    
    private func movieCellSelected(movie: Movie) {
        let vc = DescriptionViewController(movie: movie)
        present(vc, animated: true, completion: nil)
    }
    
    private func scrollDirectionCallBack(direction: MoviePosterCollectionViewCellWithCollectionView.scrollDirection) {
        switch direction {
        case .up:
            showSearchButton()
        case .down:
            hideSearchButton()
        }
    }
}
