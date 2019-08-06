//
//  UIManager.swift
//  LinkTower
//
//  Created by Hanson on 2018/6/2.
//  Copyright © 2018 Hanson. All rights reserved.
//

import UIKit

class UIManager: NSObject {

    class var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }

    public class func makeTabBarController() -> UITabBarController {
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = makeChildViewControllers()
        tabBarVC.selectedIndex = 0
        return tabBarVC
    }

    class func makeChildViewControllers() -> [UIViewController] {

        let cons: [(UIViewController.Type, String, String)] =
            [(ViewController.self, "资讯", "资讯"),
             (ViewController.self, "行情", "上升"),
             (ViewController.self, "我的", "我的")]

        return cons.map {
            let vc = NavigationController(rootViewController: $0.init())

            vc.topViewController?.title = $1
            vc.tabBarItem = UITabBarItem(title: $1,
                                         image: $2.originalImage,
                                         selectedImage: $2.templateImage)

            return vc
        }
    }
}

public func openLoginWindow(form viewController: UIViewController) {
    let vc = NavigationController(rootViewController: ViewController())
    viewController.present(vc, animated: true, completion: nil)
}
