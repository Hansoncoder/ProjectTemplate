//
//  NibLoadable.swift
//  Hanson
//
//  Created by Hanson on 9/7/17.
//  Copyright © 2017 Hanson. All rights reserved.
//

import UIKit

protocol NibLoadable {
    static var nibName: String { get }
}

extension UITableViewCell: NibLoadable {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: NibLoadable {
    static var nibName: String {
        return String(describing: self)
    }
}
