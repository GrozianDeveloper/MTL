//
//  WatchOnlineSentTableViewCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 14.05.2021.
//

import UIKit

final class OnlineActivityTableViewCell: UITableViewCell {
    
    static let identifier = "OnlineActivityTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "OnlineActivityTableViewCell", bundle: nil)
    }
    
    @IBOutlet private weak var iconImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    enum Statment {
        case watchOnline(String)
        case sendToAFriend
    }
    
    public func configure(cellType: Statment) {
        switch cellType {
        case .watchOnline(let platform):
            titleLabel.text = platform
        case .sendToAFriend:
            iconImageView.image = UIImage(systemName: "square.and.arrow.up")
            titleLabel.text = "Send to a friend"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
    }
}
