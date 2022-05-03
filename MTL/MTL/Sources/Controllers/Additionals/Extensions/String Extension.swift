//
//  String Extension.swift
//  MTL
//
//  Created by Bogdan Grozyan on 10.05.2021.
//

import Foundation

extension String {
    func convertToBeautifulDateFormate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = "d MMMM yyyy"
        return  dateFormatter.string(from: date)
    }
    
    
}

extension StringProtocol {
    var firstUpperCased: String {
        return prefix(1).uppercased() + dropFirst() 
    }
}
