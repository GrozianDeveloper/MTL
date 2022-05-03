//
//  SeeOnPlatformCollectionViewCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 24.05.2021.
//

import UIKit

final class OnlineActivityCollectionViewCell: UICollectionViewCell, Nibable {
    
    @IBOutlet weak private var platformNameLabel: UILabel!
    @IBOutlet weak private var leftImageView: UIImageView!
    
    enum ActivityType {
        case seeOnPlatform(name: String)
        case sendToFriend
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        leftImageView.layer.cornerRadius = leftImageView.frame.height / 2
    }
    
    func configure(with type: ActivityType) {
        switch type {
        case .seeOnPlatform(let name):
            leftImageView.image = UIImage(systemName: "house.fill")
            platformNameLabel.text = "See on \(name)"
        case .sendToFriend:
            leftImageView.image = UIImage(systemName: "square.and.arrow.up")
            platformNameLabel.text = "Send to a friend"
        }
    }
}
