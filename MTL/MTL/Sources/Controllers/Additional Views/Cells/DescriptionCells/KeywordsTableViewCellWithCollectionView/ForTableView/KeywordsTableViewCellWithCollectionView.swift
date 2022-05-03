//
//  KeywordsTableViewCellWithCollectionView.swift
//  MTL
//
//  Created by Bogdan Grozyan on 27.05.2021.
//

import UIKit

class KeywordsTableViewCellWithCollectionView: UITableViewCell {
    
    static let identifier = "KeywordsTableViewCellWithCollectionView"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = CGSize(width: 110, height: 40)
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
    
    var keywordCellCallBack: ((_ keyword: Keyword) -> ())?
    
    private var keywords: [Keyword]?
    
    public func configure(with keywords: [Keyword]?) {
        self.keywords = keywords?.map { keyword in
            let coolKeyword = Keyword(id: keyword.id,
                                      name: keyword.name.firstUpperCased)
            return coolKeyword
        }
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
}

extension KeywordsTableViewCellWithCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords?.count ?? 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResizableLabelCollectionViewCell.identifier, for: indexPath) as! ResizableLabelCollectionViewCell
        cell.configure(with: keywords?[indexPath.row].name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let keywordUpperCased = keywords?[indexPath.row] else {
            return
        }
        let keyword = Keyword(id: keywordUpperCased.id,
                              name: keywordUpperCased.name.firstUpperCased)
        keywordCellCallBack?(keyword)
    }
}

