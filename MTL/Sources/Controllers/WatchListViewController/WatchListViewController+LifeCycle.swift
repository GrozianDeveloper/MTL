//
//  WatchListViewContrller.swift
//  MTL
//
//  Created by Bogdan Grozian on 02.05.2022.
//

import UIKit

// MARK: - Life Cycle
extension WatchListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup
extension WatchListViewController {
    private func setupUI() {
        listTypeCollectionView.delegate = self
        listTypeCollectionView.dataSource = self
        view.addSubview(listTypeCollectionView)
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        view.addSubview(mainCollectionView)
        addConstraints()
    }
    
    private func addConstraints() {
        listTypeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listTypeCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listTypeCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listTypeCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            listTypeCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            mainCollectionView.topAnchor.constraint(equalTo: listTypeCollectionView.safeAreaLayoutGuide.bottomAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
