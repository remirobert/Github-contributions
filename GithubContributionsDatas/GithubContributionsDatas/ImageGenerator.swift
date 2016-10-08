//
//  ImageGenerator.swift
//  GithubContributionsDatas
//
//  Created by Remi Robert on 06/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

open class ImageContribution {

    public static func generate(withContributions contributions: [Contribution]) -> UIImage? {
        let sizeElement = UIScreen.main.bounds.size.width / 53
        let size = CGSize(width: UIScreen.main.bounds.size.width, height: 7 * sizeElement)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        var lineX: CGFloat = 0.0
        var lineY: CGFloat = 0.0
        
        for (index, contribution) in contributions.enumerated() {
            if index > 0 && index % 7 == 0 {
                lineY = 0
                lineX += sizeElement
            }
            
            let color = UIColor.initFrom(hex: contribution.color)
            color.setFill()
            
            let rect = CGRect(x: lineX, y: lineY, width: sizeElement, height: sizeElement)
            context.fill(rect)
            
            lineY += sizeElement
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}
