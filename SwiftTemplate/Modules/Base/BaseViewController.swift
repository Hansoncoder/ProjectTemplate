//
//  BaseViewController.swift
//  Hanson
//
//  Created by Hanson on 9/2/17.
//  Copyright © 2017 Hanson. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var rootVC: BaseViewController?
    var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = globalBgColor
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: navBarColor), for: .default)
//        navigationController?.navigationBar.isTranslucent = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

}
