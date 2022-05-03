//
//  Array Extension.swift
//  MTL
//
//  Created by Bogdan Grozyan on 28.05.2021.
//

import Foundation

extension Sequence where Element: Hashable {
    func removeDuplicated() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
