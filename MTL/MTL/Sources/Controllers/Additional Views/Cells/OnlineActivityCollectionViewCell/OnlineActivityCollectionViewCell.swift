//
//  SeeOnPlatformCollectionViewCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 24.05.2021.
//

import UIKit

final class OnlineActivityCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "OnlineActivityCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "OnlineActivityCollectionViewCell", bundle: nil)
    }
    
    enum activityType {
        case seeOnPlatform(name: String)
        case sendToFriend
    }
    
    @IBOutlet weak private var platformNameLabel: UILabel!
    @IBOutlet weak private var leftImageView: UIImageView!
    
    public func configure(with type: activityType) {
        
        switch type {
        case .seeOnPlatform(let name):
            leftImageView.image = UIImage(systemName: "house.fill")
            platformNameLabel.text = "See on \(name)"
        case .sendToFriend:
            leftImageView.image = UIImage(systemName: "square.and.arrow.up")
            platformNameLabel.text = "Send to a friend"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftImageView.layer.cornerRadius = leftImageView.frame.height / 2
    }
}
