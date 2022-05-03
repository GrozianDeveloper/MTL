//
//  WatchListViewController+CollectionView.swift
//  MTL
//
//  Created by Bogdan Grozian on 02.05.2022.
//

import UIKit

// MARK: - Delegate
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
}


// MARK: - DataSource
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

// MARK: - Higlight Feature
private extension WatchListViewController {
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
// MARK: - Support
private extension WatchListViewController {
    func movieCellSelected(movie: Movie) {
        let vc = DescriptionViewController.init(movie: movie)
        self.present(vc, animated: true, completion: nil)
    }
}
