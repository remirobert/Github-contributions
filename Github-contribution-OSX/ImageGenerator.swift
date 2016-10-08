//
//  ImageGenerator.swift
//  Github-contribution-OSX
//
//  Created by Remi Robert on 08/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

open class ImageContribution {
    
    public static func generate(withContributions contributions: [Contribution]) -> NSImage {
        let sizeElement = CGFloat(440 / 53)
        let image = NSImage(size: NSSize(width: 440, height: sizeElement * 8))

        var lineX: CGFloat = 0.0
        var lineY: CGFloat = sizeElement * 7
        
        for (index, contribution) in contributions.enumerated() {
            if index > 0 && index % 7 == 0 {
                lineY = sizeElement * 7
                lineX += sizeElement
            }

            image.lockFocus()
            let color = NSColor.initFrom(hex: contribution.color)
            color.setFill()
            
            NSBezierPath(rect: NSRect(x: lineX, y: lineY, width: sizeElement, height: sizeElement)).fill()
            
            image.unlockFocus()
            
            lineY -= sizeElement
        }
        return image
    }
}
