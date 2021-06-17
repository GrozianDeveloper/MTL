//
//  MoviePosterCollectionViewCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 09.05.2021.
//

import UIKit

final class PosterCollectionViewCell: UICollectionViewCell {

    static let identifier = "PosterCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PosterCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet private weak var posterImageView: UIImageView!
    
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet weak var nameLabelTrailingAnchor: NSLayoutConstraint!
    
    @IBOutlet private weak var  movieStatmentIndicatorLabel: UILabel!
    
    @IBOutlet weak var indicatorWidthAnchor: NSLayoutConstraint!
    
    private let dataProvider = DataProvider.shared
    
    func configure(with movie: Movie?, isCellInWantWatchedVC: Bool) {
        if let movie = movie {
            if !isCellInWantWatchedVC {
                switch movie.watchStatment {
                case .none:
                    movieStatmentIndicatorLabel.isHidden = true
                case .wanted:
                    movieStatmentIndicatorLabel.isHidden = false
                    movieStatmentIndicatorLabel.backgroundColor = .lightGray
                    movieStatmentIndicatorLabel.textColor = .lightGray
                    UIView.animate(withDuration: 1) { [weak self] in
                        self?.indicatorWidthAnchor.constant = 17
                    }
                case .watched:
                    movieStatmentIndicatorLabel.isHidden = false
                    movieStatmentIndicatorLabel.backgroundColor = .link
                    movieStatmentIndicatorLabel.textColor = .link
                    UIView.animate(withDuration: 1) { [weak self] in
                        self?.indicatorWidthAnchor.constant = 17
                    }
                }
            } else {
                movieStatmentIndicatorLabel.isHidden = true
            }
            movieNameLabel.backgroundColor = .systemBackground
            nameLabelTrailingAnchor.constant = 0
            
            movieNameLabel.text = movie.name
            if let image = movie.posterImage {
                posterImageView.image = image
            } else if let url = movie.posterImageURL {
                dataProvider.getImageWithCaching(url: url) { [weak self] in
                    self?.posterImageView.image = $0
                }
            } else {
                posterImageView.image = UIImage(named: "MovieImage")
            }
        } else {
            movieNameLabel.backgroundColor = UIColor.placeHolderColor
            posterImageView.backgroundColor = UIColor.placeHolderColor
            nameLabelTrailingAnchor.constant = 50
            
            movieNameLabel.text = ""
        }
    }
}
