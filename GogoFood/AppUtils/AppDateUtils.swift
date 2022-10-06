//
//  AppDateUtils.swift
//  GogoFood
//
//  Created by MAC on 27/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
class TimeDateUtils {
    static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return f
    }()
    
    static func getDateinDateFormat(fromDate: String) -> Date {
        return formatter.date(from: fromDate) ?? Date()
    }
    
    static func getDateOnly(fromDate: String) -> String {
        let d = formatter.date(from: fromDate)
        let f = DateFormatter()
        f.dateFormat = "dd MMM yyyy"
        if let date = d {
            return f.string(from: date)
        }
        return ""
    }
   
    static func getTime(fromDate: String) -> String {
        let d = formatter.date(from: fromDate)
        let f = DateFormatter()
        f.dateFormat = "hh:mm a"
        if let date = d {
            return f.string(from: date)
        }
        return ""
    }
    
    static func getDataWithTime(fromDate: String) -> String {
        let d = formatter.date(from: fromDate)
        let f = DateFormatter()
        f.dateFormat = "dd-MM-yyyy hh:mm a"
        if let date = d {
            return f.string(from: date)
        }
        return ""
    }
    
    
    static func getAgoTime(fromDate: String) -> String {
         let d = formatter.date(from: fromDate)
        return d?.getElapsedInterval() ?? ""
    }
    
}

extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago" :
                "\(hour)" + " " + "hour ago"
        }else if let day = interval.minute, day > 0 {
            return day == 1 ? "\(day)" + " " + "minute ago" :
                "\(day)" + " " + "miutes ago"
        }else {
            return "a moment ago"
            
        }
    
    }
}
