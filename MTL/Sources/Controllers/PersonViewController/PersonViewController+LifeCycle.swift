//
//  PersonViewController+LifeCycle.swift
//  MTL
//
//  Created by Bogdan Grozian on 02.05.2022.
//

import UIKit

// MARK: Life Cycle
extension PersonViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Setup
private extension PersonViewController {
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PersonCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PersonCollectionReusableView.identifier)
        collectionView.register(PosterCollectionViewCell.nib, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.register(OnlineActivityCollectionViewCell.nib, forCellWithReuseIdentifier: OnlineActivityCollectionViewCell.identifier)

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
