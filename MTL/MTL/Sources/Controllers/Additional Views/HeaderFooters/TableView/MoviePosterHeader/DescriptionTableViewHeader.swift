//
//  DescriptionTableViewHeader.swift
//  MTL
//
//  Created by Bogdan Grozyan on 09.05.2021.
//

import UIKit

final class DescriptionTableViewHeader: UITableViewHeaderFooterView {
    
    static let identifier = "DescriptionTableViewHeader"
    
    static func nib() -> UINib {
        return UINib(nibName: "DescriptionTableViewHeader", bundle: Bundle.main)
    }

    @IBOutlet private weak var posterImageView: UIImageView!
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    @IBOutlet private weak var releaseDateLabel: UILabel!
    
    private let dataProvider = DataProvider.shared
    
    public func configure(movie: Movie) {
        posterImageView.image = movie.posterImage
        nameLabel.text = movie.name
        releaseDateLabel.text = movie.releaseDate
    }
}
