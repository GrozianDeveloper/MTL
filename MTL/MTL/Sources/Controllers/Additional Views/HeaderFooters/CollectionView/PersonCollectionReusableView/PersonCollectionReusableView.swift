//
//  PersonCollectionReusableView.swift
//  MTL
//
//  Created by Bogdan Grozyan on 27.05.2021.
//

import UIKit

final class PersonCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "PersonCollectionReusableView"
    
    static func nib() -> UINib {
        return UINib(nibName: "PersonCollectionReusableView", bundle: nil)
    }
    
    @IBOutlet private weak var profileImageView: UIImageView!
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var jobLabel: UILabel!
    
    private let dataProvider = DataProvider.shared
    
    public func configure(person: Person) {
        if let image = person.profileImage {
            profileImageView.image = image
        } else if let url = person.profileImageURL {
            dataProvider.getImageWithCaching(url: url) { [weak self] image in
                self?.profileImageView.image = image
            }
        } else {
            profileImageView.image = UIImage(named: "PersonImage")
        }
        
        nameLabel.text = person.name
        jobLabel.text = person.job ?? person.deportament ?? person.character
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
