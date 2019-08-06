//
//  TableViewFactory.swift
//  Hanson
//
//  Created by Hanson on 9/13/17.
//  Copyright © 2017 Hanson. All rights reserved.
//

import UIKit

class TableViewFactory {

    class func createTableView(_ viewController: UIViewController?) -> UITableView {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = grayBgColor
        view.tableFooterView = UIView()
        view.separatorStyle = .none
        view.estimatedRowHeight = 0
        view.estimatedSectionHeaderHeight = 0
        view.estimatedSectionFooterHeight = 0
        view.rowHeight = UITableView.automaticDimension

        if let vc = viewController {
            view.dataSource = vc as? UITableViewDataSource
            view.delegate = vc as? UITableViewDelegate

            if #available(iOS 11.0, *) {
                view.contentInsetAdjustmentBehavior = .never
            } else {
                vc.automaticallyAdjustsScrollViewInsets = false
            }
        }
        return view
    }
}
