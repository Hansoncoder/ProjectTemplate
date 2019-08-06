//
//  LTAPI.swift
//  LinkTower
//
//  Created by Hanson on 2018/6/2.
//  Copyright © 2018 Hanson. All rights reserved.
//

import UIKit

public enum APIPath: String {
    case invalidURL = "Invalid path"

    // MARK: - 用户
    case home = "902"

    var path: String {
        return self.rawValue
    }
}

extension String {
    public func addHost() -> String {
        return LTAPI(.invalidURL).host + self
    }
}

class LTAPI: NSObject, API {

    // MARK: - init form APIPath
    var api: APIPath = .invalidURL
    convenience init(_ path: APIPath) {
        self.init()
        self.api = path
    }

    // MARK: - API
    var header: [String : Any]?
    var host: String = "http://xinwen2.021boteman.com/Home/Article/ajaxArticle/id/"
    var path: String {
        return api.path
    }
    var url: String? {
        switch self.api {
        case .invalidURL:
            return nil
        default:
            return host + api.path
        }
    }

    // MARK: - parameter
    public var params: [String : Any]? // 外界传入的参数
    private var baseParams: [String : Any] = { // 公共参数
        var params: [String : Any]  = [:]
//        if User.isLogin() {
//            params["access_token"] = User.loginUser()?.accessToken
//        }
        return params
    }()
    internal var parameter: [String : Any]? { // 拼接完整参数
        if var parameters = params {
            for (key, value) in baseParams {
                parameters[key] = value
            }
            return parameters
        }
        return baseParams
    }
}
