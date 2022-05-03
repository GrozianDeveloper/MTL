//
//  MoviePosterTableViewCellWithCollectionView.swift
//  MTL
//
//  Created by Bogdan Grozyan on 08.05.2021.
//

import UIKit

final class RelatedMoviePosterTableViewCellWithCollectionView: UITableViewCell {
    
    static let identifier = "RelatedMoviePosterTableViewCellWithCollectionView"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterCollectionViewCell.nib(), forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return collectionView
    }()
    
    var movieCellCallBack: ((_ movie: Movie) -> ())?
    
    private var posters: [Movie]?
    
    public func configure(with movieData: [Movie]?) {
        posters = movieData
        posters = posters?.compactMap { $0 }
        posters?.sort(by: { $0.popularity! > $1.popularity!})
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUIFrames()
    }
    
    private func addUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)
    }
    
    private func setupUIFrames() {
        collectionView.frame = contentView.bounds
    }
}

// MARK: UICollectionViewDataSource
extension RelatedMoviePosterTableViewCellWithCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
        cell.configure(with: posters?[indexPath.row], isCellInWantWatchedVC: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters?.count ?? 20
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension RelatedMoviePosterTableViewCellWithCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = posters?[indexPath.row] else { return }
//        delegate?.movieCellSelected(movie: poster)
        movieCellCallBack?(movie)
    }
}
