//
//  IdentifierForCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 16.06.2021.
//

import UIKit

protocol IdentifierForCell: NSObject {
    static func identifier() -> String
}

extension IdentifierForCell {
    static func identifier() -> String {
        var identifier = self.description()
        identifier.forEach { _ in
            if identifier.contains(".") { identifier.removeFirst() }
        }
        return identifier
    }
}
