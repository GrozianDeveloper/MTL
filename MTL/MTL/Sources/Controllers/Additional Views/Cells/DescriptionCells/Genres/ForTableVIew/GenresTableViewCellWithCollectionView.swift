//
//  GenresTableViewCellWithCollectionView.swift
//  MTL
//
//  Created by Bogdan Grozyan on 12.05.2021.
//

import UIKit

final class GenresTableViewCellWithCollectionView: UITableViewCell {
    
    static let identifier = "GenresTableViewCellWithCollectionView"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ResizableLabelCollectionViewCell.nib(), forCellWithReuseIdentifier: ResizableLabelCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var genreCellCallBack: ((_ genre: Genre) -> ())?
    
    private var genres: [Genre]?
    
    public func configure(with genres: [Genre]?) {
        self.genres = genres
        
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
}

extension GenresTableViewCellWithCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResizableLabelCollectionViewCell.identifier, for: indexPath) as! ResizableLabelCollectionViewCell
        cell.configure(with: genres?[indexPath.row].name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let genre = genres?[indexPath.row] else {
            return
        }
        genreCellCallBack?(genre)
    }
    
    
}
