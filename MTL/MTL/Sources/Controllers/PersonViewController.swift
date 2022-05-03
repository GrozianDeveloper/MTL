//
//  PersonView.swift
//  MTL
//
//  Created by Bogdan Grozyan on 19.05.2021.
//

import UIKit
import SafariServices

final class PersonViewController: UIViewController, SFSafariViewControllerDelegate {
    private var dataProvider = DataProvider.shared
    
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
    
    public let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PersonCollectionReusableView.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PersonCollectionReusableView.identifier)
        collectionView.register(PosterCollectionViewCell.nib(), forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.register(OnlineActivityCollectionViewCell.nib(), forCellWithReuseIdentifier: OnlineActivityCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionView
    }()
    
    private let person: Person
    
    private var movies: [Movie]?
    private var currentLastPage = 1
    private var maxPage = 1
    
    private enum sectionType {
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
    
    private var sections: [sectionType] = [.imdb, .sendToFriend, .movies]
    
    private var personEexternalID: PersonExternalIDsResponse?
    
    public func configureMovies(with moviesResponse: MoviesResponse) {
        guard let results = moviesResponse.results else {
            return
        }
        self.movies = (results.compactMap( { $0 }).sorted(by: { $0.popularity! > $1.popularity!}))
        collectionView.reloadData()
        guard let totalPages = moviesResponse.totalPages else {
            return
        }
        
        maxPage = totalPages
    }
    
    public func configurePersonExternalIDs(with personIDs: PersonExternalIDsResponse) {
        personEexternalID = personIDs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func shareContent(items: [Any]) {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension PersonViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .imdb:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnlineActivityCollectionViewCell.identifier, for: indexPath) as! OnlineActivityCollectionViewCell
            cell.configure(with: .seeOnPlatform(name: sections[indexPath.section].titleForCell))
            return cell
        case .sendToFriend:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnlineActivityCollectionViewCell.identifier, for: indexPath) as! OnlineActivityCollectionViewCell
            cell.configure(with: .sendToFriend)
            return cell
        case .movies:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
            cell.configure(with: movies?[indexPath.row], isCellInWantWatchedVC: false)
        return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .imdb, .sendToFriend:
            return 1
        case .movies:
            return movies?.count ?? 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PersonCollectionReusableView.identifier, for: indexPath) as! PersonCollectionReusableView
            header.configure(person: person)
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch sections[section] {
        case .imdb:
            return CGSize(width: collectionView.contentSize.width, height: 470)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension PersonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case .imdb, .sendToFriend:
            return CGSize(width: collectionView.contentSize.width, height: 40)
        case .movies:
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let width: CGFloat = (collectionView.frame.size.width - space) / 2.2
            let cellWidth: CGFloat = (collectionView.contentSize.width < 180 * 2 + space) ? width : 180
            return CGSize(width: cellWidth, height: cellWidth * 1.33)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .imdb:
            guard let id = personEexternalID?.imdb,  let url = URL(string: "https://www.imdb.com/name/\(id)/") else {
                return
            }
            let vc = SFSafariViewController.init(url: url)
            self.present(vc, animated: true, completion: nil)
        case .sendToFriend:
            var shareArray = [Any]()
            if let id = personEexternalID?.imdb {
                shareArray.append(URL(string: "https://www.imdb.com/name/\(id)/")!)
            } else if let id = personEexternalID?.twitter {
                shareArray.append(URL(string: "https://twitter.com/\(id)/")!)
            } else if let id = personEexternalID?.facebook {
                shareArray.append(URL(string: "https://www.facebook.com/\(id)/")!)
            } else {
                break
            }
            shareContent(items: shareArray)
        case .movies:
            guard let movie = movies?[indexPath.row] else {
                return
            }
            let vc = DescriptionViewController.init(movie: movie)
            self.present(vc, animated: true, completion: nil)
        }
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else {
//                return
//            }
//            let sectionType = self.sections[indexPath.section]
//            switch sectionType {
//            case .faceBook:
//                guard let id = personEexternalID!.facebook else {
//                    return
//                }
//                let url = URL(string: "https://www.facebook.com/\(id)/")!
//    //            https://www.facebook.com/viktor.grozan1
//                let vc = SFSafariViewController.init(url: url)
//                vc.delegate = self
//                self.present(vc, animated: true, completion: nil)
//            case .imdb:
//                guard let id = personEexternalID!.imdb else {
//                    return
//                }
//
//                let url = URL(string: "https://www.imdb.com/title/\(id))/")!
//                let vc = SFSafariViewController.init(url: url)
//                self.present(vc, animated: true, completion: nil)
//            case .twitter:
//                guard let id = personEexternalID!.twitter else {
//                    return
//                }
//    //            https://twitter.com/jacobgrozian
//                let url = URL(string: "https://twitter.com/\(id)/")!
//                let vc = SFSafariViewController.init(url: url)
//                self.present(vc, animated: true, completion: nil)
//            case .instagram:
//                guard let id = personEexternalID?.instagram else {
//                    return
//                }
//                let url = URL(string: "https://www.instagram.com/\(id)/")!
//                let vc = SFSafariViewController.init(url: url)
//                self.present(vc, animated: true, completion: nil)
//            case .sendToFriend:
//                guard let id = personEexternalID!.imdb else {
//                    return
//                }
//
//                if let url = URL(string: "https://www.imdb.com/title/\(id))/")! {
//                    self?.shareContent(items: [url])
//                    tableView.deselectRow(at: [3, 0], animated: true)
//                } else {
//                    self?.lastOnlineActivityCellThatWasTapped = .sentToFriend
//                    self?.activityIndicator.startAnimating()
//                }
//            case .movies:
//                guard let movie = movies?[indexPath.row] else {
//                    return
//                }
////
//                self.present(DescriptionViewController.init(movie: movie), animated: true, completion: nil)
//            }
//        }
    }
}
