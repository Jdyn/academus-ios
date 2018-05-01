//
//  .swift
//  SwiftData
//
//  Created by Jaden Moore on 2/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let navigationsLightGrey = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
    static let navigationsMediumGrey = UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 1)
    static let navigationsDarkGrey = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    
    static let navigationsRed = UIColor(red: 239/255, green: 83/255, blue: 80/255, alpha: 1)
    static let navigationsWhite = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    static let navigationsGreen = UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 1)
    static let navigationsBlue = UIColor(red: 30/255, green: 136/255, blue: 229/255, alpha: 1)
    static let navigationsOrange = UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
    static let navigationsPink = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
    static let navigationsDarkGreen = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1)
    
    static let tableViewGrey = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1)
    static let tableViewLightGrey = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
    static let tableViewMediumGrey = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)// were 45/45/45
    static let tableViewDarkGrey = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1) // were 40/40/40
    static let tableViewSeperator = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1)
    
    static let ghostText = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 0.3)
    
    static func blend(colors: [UIColor]) -> UIColor {
        let numberOfColors = CGFloat(colors.count)
        var (red, green, blue, alpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        
        let componentsSum = colors.reduce((red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat())) { temp, color in
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return (temp.red+red, temp.green + green, temp.blue + blue, temp.alpha+alpha)
        }
        return UIColor(red: componentsSum.red / numberOfColors,
                       green: componentsSum.green / numberOfColors,
                       blue: componentsSum.blue / numberOfColors,
                       alpha: componentsSum.alpha / numberOfColors)
    }
}
