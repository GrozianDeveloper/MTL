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
    
    var dataProvider = DataProvider.shared
    
    func updateDataProviderProperty(with dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    var wantList = [MovieCoreData]()
    var watchedList = [MovieCoreData]()
    
    let sections = SectionType.allCases
    
    let listTypeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MoviePosterCollectionViewCellWithCollectionView.self, forCellWithReuseIdentifier: MoviePosterCollectionViewCellWithCollectionView.identifier)
        collectionView.register(MovieTypeCollectionViewCell.self, forCellWithReuseIdentifier: MovieTypeCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MoviePosterCollectionViewCellWithCollectionView.self, forCellWithReuseIdentifier: MoviePosterCollectionViewCellWithCollectionView.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var currentHighlitedSection = 0
}

// MARK: Models
extension WatchListViewController {
    enum SectionType: CaseIterable {
        case want
        case watched
        
        var title: String {
            switch self {
            case .want: return "Want"
            case .watched: return "Watched"
            }
        }
    }
}
