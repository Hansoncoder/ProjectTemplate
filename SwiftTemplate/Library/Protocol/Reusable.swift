//
//  Reusable.swift
//  Hanson
//
//  Created by Hanson on 9/7/17.
//  Copyright © 2017 Hanson. All rights reserved.
//

import UIKit
import QuickLook

protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView: Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
