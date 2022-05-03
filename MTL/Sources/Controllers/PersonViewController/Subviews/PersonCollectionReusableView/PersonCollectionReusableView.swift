//
//  PersonCollectionReusableView.swift
//  MTL
//
//  Created by Bogdan Grozyan on 27.05.2021.
//

import UIKit

final class PersonCollectionReusableView: UICollectionReusableView, Nibable {

    private let dataProvider = DataProvider.shared

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var jobLabel: UILabel!
    
    func configure(person: Person) {
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
}
