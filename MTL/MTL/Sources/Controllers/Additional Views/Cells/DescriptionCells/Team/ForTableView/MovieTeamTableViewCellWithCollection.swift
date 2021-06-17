//
//  MovieTeamTableViewCellWithCollection.swift
//  MTL
//
//  Created by Bogdan Grozyan on 09.05.2021.
//

import UIKit

final class TeamTableViewCellWithCollectionView: UITableViewCell {
    
    static let identifier = "TeamTableViewCellWithCollectionView"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieTeamCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieTeamCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return collectionView
    }()
    
//    var delegate: CellCallBacksInsideCollectionView?
    
    var castCellCallBack: ((_ person: Person) -> ())?
    
    private var people: [Person]?
    
    public func configure(with team: [Person]?) {
        people = team
        people = people?.sorted(by: { $0.popularity! > $1.popularity! })
        
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
}

extension TeamTableViewCellWithCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieTeamCollectionViewCell.identifier, for: indexPath) as! MovieTeamCollectionViewCell
            cell.configure(with: people?[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people?.count ?? 20
    }
    
}

extension TeamTableViewCellWithCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = contentView.frame.height - 1
        let cellWidth: CGFloat = height * 0.75
        return CGSize(width: cellWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let person = people?[indexPath.row] else {
            return
        }
        
//        delegate?.castCellSelected(person: dude)
        castCellCallBack?(person)
    }
}
