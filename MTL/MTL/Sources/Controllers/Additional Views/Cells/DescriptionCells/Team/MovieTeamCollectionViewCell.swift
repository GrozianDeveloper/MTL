//
//  MovieTeamCollectionViewCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 08.05.2021.
//

import UIKit

final class MovieTeamCollectionViewCell: UICollectionViewCell {

    static let identifier = "MovieTeamCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieTeamCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var deportamentLabel: UILabel!
    
    private let dataProvider = DataProvider.shared
    
    public func configure(with dude: Person?) {
        if dude != nil {
            nameLabel.text = dude?.name ?? "Sir Eliott"
            nameLabel.textColor = .label
            nameLabel.backgroundColor = .systemBackground
            
            deportamentLabel.text = dude?.character ?? dude?.job ?? dude?.deportament ?? "Crew mate"
            deportamentLabel.textColor = .secondaryLabel
            deportamentLabel.backgroundColor = .systemBackground
            if let image = dude?.profileImage {
                imageView.image = image
            } else if let url = dude?.profileImageURL {
                dataProvider.getImageWithCaching(url: url) { [weak self] image in
                    self?.imageView.image = image
                }
            } else {
                imageView.image = UIImage(named: "PersonImage")
            }
        } else {
            imageView.backgroundColor = UIColor.placeHolderColor
            
            nameLabel.textColor = UIColor.placeHolderColor
            nameLabel.backgroundColor = UIColor.placeHolderColor
            
            deportamentLabel.textColor = UIColor.placeHolderColor
            deportamentLabel.backgroundColor = UIColor.placeHolderColor
        }
    }

}
