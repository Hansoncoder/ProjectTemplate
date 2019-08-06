//
//  RegularTool.swift
//  LinkTower
//
//  Created by Hanson on 2018/5/24.
//  Copyright © 2018 Hanson. All rights reserved.
//
import Foundation

public enum RegexType: String {
    case phoneNumber = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    case passWord = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
    case nickname = "^[\u{4e00}-\u{9fa5}]{4,8}$"

    func predicate() -> NSPredicate {
        return NSPredicate(format: "SELF MATCHES %@", self.rawValue)
    }
}

extension String {

    public func validate(regex: RegexType) -> Bool {
        let phonePredicate = regex.predicate()
        return phonePredicate.evaluate(with: self)
    }
}
