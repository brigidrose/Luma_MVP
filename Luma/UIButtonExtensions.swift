//
//  UIButtonExtensions.swift
//  Speakout
//
//  Created by Chun-Wei Chen on 4/9/16.
//  Copyright © 2016 Eddie Chen. All rights reserved.
//

import Foundation
import DynamicColor

extension UIButton {
    
//    static let blackColor = UIColor.colorWithHex("323232")
//    static let redColor = UIColor.colorWithHex("FF4646")
//    static let yellowColor = UIColor.colorWithHex("FFDF89")
//    static let whiteColor = UIColor.whiteColor()
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControlState) {
        self.setBackgroundImage(imageWithColor(color), forState: state)
    }
    
    func setBorderWithRoundedCorners(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = self.titleColorForState(UIControlState.Normal)?.CGColor
        self.layer.borderWidth = 0
        self.clipsToBounds = true
    }
    
    func setButtonType(type:String) {
        
        var buttonColor:UIColor!
        var buttonTextColor:UIColor!
        
        switch type {
        case "primary":
            buttonColor = Colors.primary
            buttonTextColor = UIColor.whiteColor()
            self.setBorderWithRoundedCorners(28)
//            self.titleEdgeInsets = UIEdgeInsetsMake(5.0, 7.5, 5.0, 7.5)
        default:
            buttonColor = Colors.primary
            buttonTextColor = UIColor.whiteColor()
            self.setBorderWithRoundedCorners(28)
//            self.titleEdgeInsets = UIEdgeInsetsMake(5.0, 7.5, 5.0, 7.5)
        }
        
        self.setBackgroundColor(buttonColor.darkerColor(), forUIControlState: .Highlighted)
        self.setBackgroundColor(buttonColor, forUIControlState: .Normal)
        self.setTitleColor(buttonTextColor, forState: .Normal)
        self.titleLabel?.font = UIFont(name: ".SFUIText-Regular", size: 22)
        
    }
    
}