//
//  CommonTools.swift
//  LinkTower
//
//  Created by Hanson on 2018/6/3.
//  Copyright © 2018年 Hanson. All rights reserved.
//

import UIKit

class CommonTools {

    public class func getText(from textField: UITextField, tipText: String) -> String? {
        guard let text = textField.text, !text.isEmpty else {
            LTHUD.flash(.label(tipText), onView: UIManager.keyWindow)
            return nil
        }
        return text
    }

    public class func getPhoneNumber(from textField: UITextField) -> String? {
        guard let text = textField.text, !text.isEmpty else {
            LTHUD.flash(.label("请输入手机号"), onView: UIManager.keyWindow)
            return nil
        }
        guard text.validate(regex: .phoneNumber) else {
            LTHUD.flash(.label("手机号格式不正确"), onView: UIManager.keyWindow)
            return nil
        }
        return text
    }
}

public func getMult(_ firstNum: Double?, _ secondNum: Double?) -> Double {
    guard let first = firstNum, let second = secondNum else {
        return 0.00
    }
    return first * second
}

public func getBilion(_ number: Double?) -> Double? {
    guard let temp = number else {
        return nil
    }
    return temp / 100000000.0
}

public func getText(_ number: Double?) -> String {
    guard let temp = number else { return "0.00" }
    return String(format: "%.2f", temp)
}
