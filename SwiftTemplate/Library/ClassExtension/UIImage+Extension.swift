//
//  UIImage+Extension.swift
//  LinkTower
//
//  Created by Hanson on 2018/6/16.
//  Copyright © 2018年 Hanson. All rights reserved.
//

import UIKit

public extension String {

    var image: UIImage? {
        return UIImage(named: self)
    }

    var templateImage: UIImage? {
        return UIImage(named: "\(self)_select")
    }

    var originalImage: UIImage? {
        return UIImage(named: "\(self)_normal")
    }
}
