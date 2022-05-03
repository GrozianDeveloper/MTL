//
//  BioForCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 16.06.2021.
//

import UIKit

protocol BioForCell: IdentifierForCell {
    static func nib() -> UINib
}

extension BioForCell {
    static func nib() -> UINib {
        return UINib(nibName: identifier(), bundle: nil)
    }
}
