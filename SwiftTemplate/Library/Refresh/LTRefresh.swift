//
//  LTRefresh.swift
//  LinkTower
//
//  Created by Hanson on 2018/6/5.
//  Copyright © 2018 Hanson. All rights reserved.
//

import UIKit
import MJRefresh

class LTRefresh: NSObject {
    class func refreshing(in scrollView: UIScrollView) -> Bool {
        guard let header = scrollView.mj_header else {
            if let footer = scrollView.mj_footer {
                return footer.isRefreshing
            }
            return false
        }
        if let footer = scrollView.mj_footer {
            return header.isRefreshing || footer.isRefreshing
        }
        
        return header.isRefreshing
    }
    
    class func addHeaderRefresh(to scrollView: UIScrollView, target: Any?, action: Selector) {
        let refreshNormalHeader = MJRefreshNormalHeader(refreshingTarget: target, refreshingAction: action)
        configHeader(refreshNormalHeader!)
        scrollView.mj_header = refreshNormalHeader
    }

    class func addFootRefresh(to scrollView: UIScrollView, target: Any?, action: Selector) {
        let refreshNormalFoot = MJRefreshAutoNormalFooter(refreshingTarget: target, refreshingAction: action)
        configFoot(refreshNormalFoot!)
        scrollView.mj_footer = refreshNormalFoot
    }

    class func beginHeaderRefresh(_ scrollView: UIScrollView) {
        scrollView.mj_header.beginRefreshing()
    }
    class func beginFooterRefresh(_ scrollView: UIScrollView) {
        scrollView.mj_footer.beginRefreshing()
    }
    class func endHeaderRefresh(_ scrollView: UIScrollView) {
        guard let header = scrollView.mj_header, header.isRefreshing else {
            return
        }
        scrollView.mj_header.endRefreshing()
    }
    class func endFooterRefresh(_ scrollView: UIScrollView) {
        guard let footer = scrollView.mj_footer, footer.isRefreshing else {
            return
        }
        scrollView.mj_footer.endRefreshing()
    }
    class func removeFooterRefresh(_ scrollView: UIScrollView) {
        scrollView.mj_header = nil
    }

    class func endRefreshingWithNoMoreData(_ scrollView: UIScrollView) {
        scrollView.mj_footer.endRefreshingWithNoMoreData()
    }

    class func hideFooterRefresh(_ scrollView: UIScrollView) {
        scrollView.mj_footer.isHidden = true
    }

    class func showFooterRefresh(_ scrollView: UIScrollView) {
        scrollView.mj_footer.isHidden = false
    }
    
    class func configHeader(_ headView: MJRefreshNormalHeader) {
        headView.setTitle("下拉刷新数据", for: .idle)
        headView.setTitle("松开立即刷新", for: .pulling)
        headView.setTitle("正在刷新...", for: .refreshing)
        headView.setTitle("正在刷新...", for: .willRefresh)
    }

    class func configFoot(_ footView: MJRefreshAutoStateFooter) {
        footView.setTitle("上拉加载更多", for: .idle)
        footView.setTitle("松开立即刷新", for: .pulling)
        footView.setTitle("正在加载数据", for: .refreshing)
        footView.setTitle("加载更多数据", for: .willRefresh)
        footView.setTitle("没有更多了", for: .noMoreData)
    }
}
