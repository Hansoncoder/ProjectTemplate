//
//  GlobalConst.swift
//  Hanson
//
//  Created by Hanson on 9/3/17.
//  Copyright © 2017 Hanson. All rights reserved.
//

import UIKit

/***** View ******/
let viewBgColor = UIColor.white
let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.height
let navHeight: CGFloat = 64
let tabbarHeight: CGFloat = 49
/****** color ******/
public func navBgColor(_ alpah: CGFloat) -> UIColor {
    return UIColor.white
}

let navBarColor = navBgColor(1.0)
let blackColor = UIColor(hex: 0x101010)
let redColor = UIColor(hex: 0xE51C23)
let blueColor = UIColor(red: 18, green: 150, blue: 225)
let blueBgColor = UIColor(hex: 0x0077ff)
let titleColor = blackColor
let globalBgColor = UIColor.white
let generalColor = UIColor(hex: 0x666666)
let grayBgColor = UIColor(hex: 0xF4F4F4)
let grayColor = UIColor(hex: 0xC8C8C8)
let lightGrayColor = UIColor(hex: 0xECECEC)
let lineColor = UIColor(hex: 0xF0F0F0)
let lineCGColor = lineColor.cgColor

let blueTextColor = UIColor(hex: 0x3a7de0)
let grayTextColor = UIColor(hex: 0xE5E6E9)
let darkGrayTextColor = UIColor(hex: 0x737070)
let blackTextColor = UIColor(hex: 0x101010)
let redTextColor = UIColor(hex: 0xE51C23)

/****** font ******/
public func boldFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: fontSize)
}
public func systemFont(size fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize)
}
let titleFont = UIFont.boldSystemFont(ofSize: 17)
let generalFont = UIFont.boldSystemFont(ofSize: 12)

/****** Notification ******/
let loginSuccessNotify = Notification.Name(rawValue: "loginSuccessNotify")
let updateUserInfoNotify = Notification.Name(rawValue: "updateUserInfoNotify")
let changeRootVC = Notification.Name(rawValue: "changeRootVC")
let dotTimerKey = Notification.Name(rawValue: "dotTimerKey")
