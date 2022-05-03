//
//  WatchOnlineSentTableViewCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 14.05.2021.
//

import UIKit

final class OnlineActivityTableViewCell: UITableViewCell, Nibable {
    
    @IBOutlet private weak var iconImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    enum Statment {
        case watchOnline(String)
        case sendToAFriend
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
    }

    func configure(cellType: Statment) {
        switch cellType {
        case .watchOnline(let platform):
            titleLabel.text = platform
        case .sendToAFriend:
            iconImageView.image = UIImage(systemName: "square.and.arrow.up")
            titleLabel.text = "Send to a friend"
        }
    }
}
