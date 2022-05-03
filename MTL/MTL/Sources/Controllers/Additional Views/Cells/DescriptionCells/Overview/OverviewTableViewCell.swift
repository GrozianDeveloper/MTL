//
//  OverviewTableViewCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 11.05.2021.
//

import UIKit

final class OverviewTableViewCell: UITableViewCell {
    
    static let identifier = "OverviewTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "OverviewTableViewCell", bundle: nil)
    }
    
    @IBOutlet private weak var overviewLabel: UILabel!
    
    public func configure(with overview: String?) {
        if overview == nil {
            overviewLabel.textColor = UIColor.placeHolderColor
            overviewLabel.backgroundColor = UIColor.placeHolderColor
        } else {
            overviewLabel.text = overview
            overviewLabel.textColor = .secondaryLabel
            overviewLabel.backgroundColor = .systemBackground
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        overviewLabel.layer.cornerRadius = overviewLabel.frame.height / 10
    }
}
