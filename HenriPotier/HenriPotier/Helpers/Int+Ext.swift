//
//  Int+Ext.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 27/4/2022.
//

import Foundation


extension Int {
    var formattedPrice: String {
        let priceFormatter = NumberFormatter()
        priceFormatter.locale = Locale(identifier: "fr_FR Locale")
        priceFormatter.numberStyle = .currency
        priceFormatter.usesGroupingSeparator = true
        priceFormatter.groupingSize = 2
        priceFormatter.currencySymbol = "€"
        
        if let formattedPrice = priceFormatter.string(from: self as NSNumber) {
            return formattedPrice
        }
        return ""
    }
}
