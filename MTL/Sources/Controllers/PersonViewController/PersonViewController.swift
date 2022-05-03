//
//  PersonView.swift
//  MTL
//
//  Created by Bogdan Grozyan on 19.05.2021.
//

import UIKit

final class PersonViewController: UIViewController {
    private var dataProvider = DataProvider.shared
    
    let person: Person

    init(person: Person) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
        if person.id == nil {
            sections.remove(at: 4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionView
    }()
    
    private(set) var sections = SectionType.allCases
    private(set) var movies: [Movie]?
    private(set) var personEexternalID: PersonExternalIDsResponse?
}

// MARK: - Configure Content
extension PersonViewController {
    func configureMovies(with moviesResponse: MoviesResponse) {
        if let results = moviesResponse.results {
            movies = results.sorted(by: { $0.popularity! > $1.popularity! })
            collectionView.reloadData()
        }
    }
    
    func configurePersonExternalIDs(with personIDs: PersonExternalIDsResponse) {
        personEexternalID = personIDs
    }
}

// MARK: - Models
extension PersonViewController {
    enum SectionType: CaseIterable {
        case imdb
        case sendToFriend
        case movies
        
        var sectionTitle: String {
            switch self {
            case .imdb: return "In popular platform"
            case .sendToFriend: return "Will not presented"
            case .movies: return "Movies"
            }
        }

        var titleForCell: String {
            switch self {
            case .imdb: return "IMDB"
            case .sendToFriend: return "Send to a friend"
            case .movies: return "Movies"
            }
        }
    }
}
