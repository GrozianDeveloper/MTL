//
//  HomeViewController.swift
//  MTL
//
//  Created by Bogdan Grozyan on 26.04.2021.
//

import UIKit

final class HomeViewController: UIViewController {
    let movieTypeCollectionView: UICollectionView = {
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
    
    let mainCollectionView: UICollectionView = {
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
    
    let goToWatchListViewControllerButton: UIButton = {
        let button = WatchListButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.blurEffectView.layer.cornerRadius = button.layer.cornerRadius
        return button
    }()
    
    let searchButton: UIButton = {
        let button = SearchButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 20
        button.blurEffectView.layer.cornerRadius = button.layer.cornerRadius
        return button
    }()
    
    var searchButtonTopConstraint: NSLayoutConstraint?
    
    var dataProvider = DataProvider.shared
    
    var recommendedMovies: MoviesData = MoviesData(type: .recommended)
    var nowPlayingMovies: MoviesData = MoviesData(type: .nowPlaying)
    var topRatedMovies: MoviesData = MoviesData(type: .topRated)
    var popularMovies: MoviesData = MoviesData(type: .popular)
    var upcomingMovies: MoviesData = MoviesData(type: .upcoming)
    
    let sections = MovieType.allCases
    var currentHighlitedSection = 0
}
