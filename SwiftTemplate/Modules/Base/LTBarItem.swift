//
//  LTBarItem.swift
//  LinkTower
//
//  Created by Hanson on 2018/6/12.
//  Copyright © 2018 Hanson. All rights reserved.
//

import UIKit

class LTBarItem: UIBarButtonItem {
    public convenience init(imageName: String, selected selectImageName: String?,
                            target: Any?, action: Selector?) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        if let name = selectImageName {
            button.setImage(UIImage(named: name), for: .selected)
        }
        let size = button.currentImage?.size
        button.frame = CGRect(x: 0, y: 0, width: size?.width ?? 0, height: size?.height ?? 0)
        button.addTarget(target, action: action!, for: .touchUpInside)
        self.init(customView: button)
    }
}
