//
//  ResizableLabelCollectionViewCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 13.05.2021.
//

import UIKit

final class ResizableLabelCollectionViewCell: UICollectionViewCell, Nibable {
    
    @IBOutlet weak var label: UILabel!
    
    func configure(with text: String?) {
        if text == nil {
            label.backgroundColor = UIColor.placeHolderColor
            label.textColor = UIColor.placeHolderColor
        } else {
            label.text = text
            label.textColor = .secondaryLabel
            label.backgroundColor = .systemBackground
        }
    }

}
