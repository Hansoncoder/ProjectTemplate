//
//  UIColor+Extension.swift
//  YiBiFen
//
//  Created by Hanson on 16/10/13.
//  Copyright © 2016年 Hanson. All rights reserved.
//

import UIKit

extension UIColor {
    //用数值初始化颜色，便于生成设计图上标明的十六进制颜色
    convenience init(hex hexText: UInt) {
        self.init(
            red: CGFloat((hexText & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexText & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexText & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init( red: red / 255.0, green: green / 255.0,
            blue: blue / 255.0, alpha: 1.0 )
    }

    public class var random: UIColor {
        get {
            let red = CGFloat(arc4random() % 256) / 255.0
            let green = CGFloat(arc4random() % 256) / 255.0
            let blue = CGFloat(arc4random() % 256) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
