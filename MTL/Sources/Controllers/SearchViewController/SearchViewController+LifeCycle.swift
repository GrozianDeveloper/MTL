//
//  SearchViewController+LifeCycle.swift
//  MTL
//
//  Created by Bogdan Grozian on 03.05.2022.
//

import UIKit

// MARK: - Life Cycle
extension SearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setuphideKeyboardWhenTappedAround()
    }
}

// MARK: - Setup
extension SearchViewController {
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RelatedMoviePosterTableViewCellWithCollectionView.self, forCellReuseIdentifier: RelatedMoviePosterTableViewCellWithCollectionView.identifier)
        tableView.register(GenresTableViewCellWithCollectionView.self, forCellReuseIdentifier: GenresTableViewCellWithCollectionView.identifier)
        tableView.register(KeywordsTableViewCellWithCollectionView.self, forCellReuseIdentifier: KeywordsTableViewCellWithCollectionView.identifier)
        tableView.register(TeamTableViewCellWithCollectionView.self, forCellReuseIdentifier: TeamTableViewCellWithCollectionView.identifier)
        tableView.register(SectionTitleTableViewHeader.nib, forHeaderFooterViewReuseIdentifier: SectionTitleTableViewHeader.identifier)
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
    }
    
    private func setuphideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Support
extension SearchViewController {
    @objc func dismissKeyboard() {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
}
