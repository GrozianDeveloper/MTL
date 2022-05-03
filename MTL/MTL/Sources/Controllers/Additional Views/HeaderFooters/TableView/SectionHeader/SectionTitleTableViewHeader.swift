//
//  SectionTitleTableViewHeader.swift
//  MTL
//
//  Created by Bogdan Grozyan on 13.05.2021.
//

import UIKit

final class SectionTitleTableViewHeader: UITableViewHeaderFooterView {
    
    static let identifier = "SectionTitleTableViewHeader"
    
    static func nib() -> UINib {
        return UINib(nibName: "SectionTitleTableViewHeader", bundle: Bundle.main)
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
}
