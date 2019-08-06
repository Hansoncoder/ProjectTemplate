//
//  Date+Extension.swift
//  LinkTower
//
//  Created by Hanson on 2018/6/5.
//  Copyright © 2018 Hanson. All rights reserved.
//

import Foundation
extension Date {

    static func getCurrentText(format: String) -> String {
        return Date().getText(format: format)
    }

    static func getCurrentWeakDay() -> String {
        return getWeakDay(for: Date())
    }



    static func getWeakDay(for date: Date) -> String {

        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day, .weekday, .hour]
        let components = calendar.components(unitFlags, from: date)
        guard let weekday = components.weekday else {
            return ""
        }
        switch weekday {
        case 1:
            return "星期天"
        case 2:
            return "星期一"
        case 3:
            return "星期二"
        case 4:
            return "星期三"
        case 5:
            return "星期四"
        case 6:
            return "星期五"
        case 7:
            return "星期六"
        default:
            return ""
        }
    }

    static func getText(from date: Date, format: String) -> String {
        return date.getText(format: format)
    }

    public func getText(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    static func getDate(from date: String, format: String = "yyyy/MM/dd HH:mm:ss")
        -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)
    }
}

extension String {
    public func toDate(_ format: String = "yyyy/MM/dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
