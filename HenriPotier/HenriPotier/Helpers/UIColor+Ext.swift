//
//  UIColor+Ext.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 23/4/2022.
//

import UIKit


extension UIColor {
    static var Background = UIColor(named: "Background")!

    static var TopTitle = UIColor(named: "TopTitle")!
    
    static var BookMarksBackground = UIColor(named: "BookMarksBackground")!
    
    static var CurrentPageControll = UIColor(named: "PageControll")!
    static var dotsInPageControll = CurrentPageControll.withAlphaComponent(0.5)

    static var PriceLabel = UIColor(named: "PriceLabel")!
    static var PriceLabelBackground = UIColor(named: "PriceLabelBackground")!

    static var LargeButtonBackground = UIColor(named: "LargeButtonBackground")!
    
    static var CartBadgeBackground = UIColor(named: "CartBadgeBackground")!
    static var CartBadgeBorder = UIColor(named: "CartBadgeBorder")!

    static var TintColor = UIColor(named: "TintColor")!
    
    static var bottomAddCartBackground = UIColor(named: "bottomAddCartBackground")!
    static var bottomPriceBackground = UIColor(named: "bottomPriceBackground")!
    static var bottomPriceTintColor = UIColor(named: "bottomPriceTintColor")!
    
    static var bookmarksBorder = UIColor(named: "bookmarksBorder")!
    
    //Extra
    static var borderColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1.000)
    static var trashColor = UIColor(red:0.643, green:0.224, blue:0.173, alpha:1.000)

    //PageControll
    static var currentPageIndicatorTintColor = UIColor(named: "currentPageIndicatorTintColor")!
    static var pageIndicatorTintColor = UIColor(named: "pageIndicatorTintColor")!

}
