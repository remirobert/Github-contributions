//
//  UIColorExtension.swift
//  GithubContributionsDatas
//
//  Created by Remi Robert on 06/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

public extension UIColor {
    public static func initFrom(hex string: String) -> UIColor {
        var cString = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines as CharacterSet)
        
        cString = cString.replacingOccurrences(of: "#", with: "")
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
