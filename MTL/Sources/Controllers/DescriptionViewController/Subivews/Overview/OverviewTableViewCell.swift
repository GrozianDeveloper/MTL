//
//  OverviewTableViewCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 11.05.2021.
//

import UIKit

final class OverviewTableViewCell: UITableViewCell, Nibable {
    
    @IBOutlet private weak var overviewLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        overviewLabel.layer.cornerRadius = overviewLabel.frame.height / 10
    }

    func configure(with overview: String?) {
        if overview == nil {
            overviewLabel.textColor = UIColor.placeHolderColor
            overviewLabel.backgroundColor = UIColor.placeHolderColor
        } else {
            overviewLabel.text = overview
            overviewLabel.textColor = .secondaryLabel
            overviewLabel.backgroundColor = .systemBackground
        }
    }
}
