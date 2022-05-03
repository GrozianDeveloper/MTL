//
//  PersonViewController+CollectionView.swift
//  MTL
//
//  Created by Bogdan Grozian on 01.05.2022.
//

import UIKit.UICollectionView
import SafariServices.SFSafariViewController

// MARK: - Delegate
extension PersonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case .imdb, .sendToFriend:
            return CGSize(width: collectionView.contentSize.width, height: 40)
        case .movies:
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? .zero) + (flowayout?.sectionInset.left ?? .zero) + (flowayout?.sectionInset.right ?? .zero)
            let width: CGFloat = (collectionView.frame.width - space) / 2.2
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
            presentActivityController(with: shareArray)
        case .movies:
            guard let movie = movies?[indexPath.row] else {
                return
            }
            let vc = DescriptionViewController(movie: movie)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch sections[section] {
        case .imdb:
            return CGSize(width: collectionView.contentSize.width, height: 470)
        default:
            return CGSize.zero
        }
    }
}

// MARK: - DataSource
extension PersonViewController: UICollectionViewDataSource {
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PersonCollectionReusableView.identifier, for: indexPath) as! PersonCollectionReusableView
            header.configure(person: person)
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - Support
extension PersonViewController {
    private func presentActivityController(with items: [Any]) {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
}
