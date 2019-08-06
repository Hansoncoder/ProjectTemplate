//
//  NavigationController.swift
//  YiBiFen
//
//  Created by Hanson on 16/10/13.
//  Copyright © 2016年 Hanson. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController,UINavigationControllerDelegate {

    private var popRecognizer: UIPanGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self
        initUI()
        initGestureRecognizer()
    }

    // MARK: - 导航栏
    private func initUI() {
        let appearance = UINavigationBar.appearance()
        // 标题
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:titleColor,
                                          NSAttributedString.Key.font:titleFont]
        // 背景
        appearance.setBackgroundImage(UIImage(color: navBarColor), for: UIBarMetrics.default)
        // 分割线
        appearance.shadowImage = UIImage()
    }

    // MARK: - 全屏返回手势
    private func initGestureRecognizer() {
        let gesture = self.interactivePopGestureRecognizer
        gesture?.isEnabled = false
        let gestureView = gesture?.view

        popRecognizer = UIPanGestureRecognizer()
        guard let popRecognizer = popRecognizer  else {
            return
        }
//        popRecognizer.delegate = self
        popRecognizer.maximumNumberOfTouches = 1
        gestureView?.addGestureRecognizer(popRecognizer)

        if let target = interactivePopGestureRecognizer?.delegate {
          popRecognizer.addTarget(target, action: Selector(("handleNavigationTransition:")))
        }

    }

     /// 判断是否需要全屏返回手势
     ///
     /// - parameter viewController: 判断的控制器
     ///
     /// - returns: true需要全屏返回 false不需要全屏返回
     private func chakeNeedPopRecognizer(viewController: UIViewController) -> Bool {
          let needPop = viewController is UITabBarController
          return needPop
     }

     // MARK: - UINavigationControllerDelegate
     // 显示View设置手势
     internal func navigationController(_ navigationController: UINavigationController,
                                        didShow viewController: UIViewController, animated: Bool) {
          let needPop = chakeNeedPopRecognizer(viewController: viewController)
          popRecognizer?.isEnabled = needPop
          interactivePopGestureRecognizer?.isEnabled = !needPop
     }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        addLeftBackButton(viewController)
        super.pushViewController(viewController, animated: true)
    }

    private func addLeftBackButton(_ viewController: UIViewController) {
        // 返回按钮
        if !children.isEmpty {
            let backButton = BackButton(type: .custom)
            backButton.setImage(#imageLiteral(resourceName: "返回箭头"), for: .normal)
            backButton.frame = CGRect(x: 0, y: 13, width: 30, height: 15)
            backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
            let backView = UIBarButtonItem(customView: backButton)
            // 返回按钮设置成功
            viewController.navigationItem.leftBarButtonItem = backView
            viewController.hidesBottomBarWhenPushed = true
            if let tabBarController = tabBarController {
                tabBarController.tabBar.isHidden = true
            }
            return
        }
        if let tabBarController = tabBarController {
            tabBarController.tabBar.isHidden = false
        }

    }

    @objc private func back() {
        popViewController(animated: true)
    }
}

class BackButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.left = 0
    }
}
