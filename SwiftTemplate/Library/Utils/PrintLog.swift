//
//  PrintLog.swift
//  LinkTower
//
//  Created by Hanson on 2018/5/24.
//  Copyright © 2018 Hanson. All rights reserved.
//

import Foundation

func printLog<T>(_ message: T,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line) {
    #if DEBUG
        let queue = Thread.isMainThread ? "UI" : "BG"
        print("<\(queue)>:\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

func printError<T>(_ message: T,
                   file: String = #file,
                   method: String = #function,
                   line: Int = #line) {
    #if DEBUG
        let queue = Thread.isMainThread ? "UI" : "BG"
        print("‼️ Error<\(queue)>:\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
