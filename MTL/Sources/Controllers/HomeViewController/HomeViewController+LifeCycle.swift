//
//  HomeViewController+LifeCycle.swift
//  MTL
//
//  Created by Bogdan Grozian on 02.05.2022.
//

import UIKit

// MARK: - Life Cycle
extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
        setupUI()
        setupFrames()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        super.dismiss(animated: flag, completion: completion)
        mainCollectionView.reloadData()
    }
}

// MARK: - Setup
extension HomeViewController {
    private func setupContent() {
        DataProvider.checkForInternetConnection { isConnected in
            if isConnected {
                self.getAllMovies()
            } else {
                print("isConnected", isConnected)
            }
        }
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

        setupFrames()
    }
    
    private func setupFrames() {
        NSLayoutConstraint.activate([
            movieTypeCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieTypeCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieTypeCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieTypeCollectionView.heightAnchor.constraint(equalToConstant: 40),

            mainCollectionView.topAnchor.constraint(equalTo: movieTypeCollectionView.safeAreaLayoutGuide.bottomAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            goToWatchListViewControllerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            goToWatchListViewControllerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            goToWatchListViewControllerButton.heightAnchor.constraint(equalToConstant: 48),
            goToWatchListViewControllerButton.widthAnchor.constraint(equalToConstant: 77),

            searchButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            searchButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            searchButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

// MARK: - Support
extension HomeViewController {
    @objc private func presentWatchlistViewController(_ sender: UIButton) {
        let vc = WatchListViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func presentSearchSearchViewController(_ sender: UIButton) {
        let vc = SearchViewController()
        self.present(vc, animated: true, completion: nil)
    }
}
