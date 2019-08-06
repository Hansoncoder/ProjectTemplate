//
//  API.swift
//  Hanson
//
//  Created by Hanson on 9/9/17.
//  Copyright © 2017 Hanson. All rights reserved.
//

import Foundation

protocol API {
    var host: String { get }
    var path: String { get }
    var url: String? { get }
    var header: [String:Any]? { get }
    var parameter: [String:Any]? { get }
}

extension API {
    var url: String? {
        return host + path
    }
}
