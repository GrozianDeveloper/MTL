//
//  DescriptionViewController+LifeCycle.swift
//  MTL
//
//  Created by Bogdan Grozian on 02.05.2022.
//

import UIKit

// MARK: - Life Cycle
extension DescriptionViewController {
    override func viewDidLoad() {
        getCurrentMovieCoreData()
        setupTableView()
        setupUI()
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

// MARK: Setup
extension DescriptionViewController {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(DescriptionTableViewHeader.nib(), forHeaderFooterViewReuseIdentifier: DescriptionTableViewHeader.identifier) // Poster
        tableView.register(SectionTitleTableViewHeader.nib, forHeaderFooterViewReuseIdentifier: SectionTitleTableViewHeader.identifier) // -_-
        tableView.register(StatementsTableViewCell.nib, forCellReuseIdentifier: StatementsTableViewCell.identifier) // MovieStatments
        tableView.register(VotePopularityRuntimeTableViewCell.nib, forCellReuseIdentifier: VotePopularityRuntimeTableViewCell.identifier) // VotePopularityRuntime
        tableView.register(OnlineActivityTableViewCell.nib, forCellReuseIdentifier: OnlineActivityTableViewCell.identifier) // WatchOnline and SentToFriend
        tableView.register(OverviewTableViewCell.nib, forCellReuseIdentifier: OverviewTableViewCell.identifier) // Overview
        tableView.register(GenresTableViewCellWithCollectionView.self, forCellReuseIdentifier: GenresTableViewCellWithCollectionView.identifier) // Genres
        tableView.register(KeywordsTableViewCellWithCollectionView.self, forCellReuseIdentifier: KeywordsTableViewCellWithCollectionView.identifier)
        tableView.register(TeamTableViewCellWithCollectionView.self, forCellReuseIdentifier: TeamTableViewCellWithCollectionView.identifier) // Team
        tableView.register(RelatedMoviePosterTableViewCellWithCollectionView.self, forCellReuseIdentifier: RelatedMoviePosterTableViewCellWithCollectionView.identifier) // RelatedMovies
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
