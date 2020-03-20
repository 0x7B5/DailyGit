//
//  DateHelper.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/28/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation

public class DateHelper {
    static let shared = DateHelper()
    private init() {}
    
    func getFormattedDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        
        return result
    }
    
    func getYesterdayDate() -> String {
        let date = Date.yesterday
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        
        return result
    }
    
    func stringToDate(myDate: String, IsoFormat: Bool) -> Date {
        let formatter = DateFormatter()
        if IsoFormat {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        } else {
            formatter.dateFormat = "yyyy-MM-dd"
        }
        
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let date = formatter.date(from: myDate)
        
        if date != nil {
            return date!
        }
        return Date()
    }
    
    func stringToYear(myDate: String, IsoFormat: Bool) -> String {
        let myDate = stringToDate(myDate: myDate, IsoFormat: IsoFormat)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: myDate)
        
        return String(year)
    }
    
    func getDayOfWeek(fromDate date: Date) -> Int {
        let cal = Calendar(identifier: .gregorian)
        let dayOfWeek = cal.component(.weekday, from: date)
        
        return dayOfWeek - 1
    }
    
    
    func getYear(myDate: String, isIso: Bool) -> Int {
        let calendar = Calendar.current
        let date = stringToDate(myDate: myDate, IsoFormat: isIso)
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        if let year = Int(String(components.year!)) {
            return year
        }
        
        return 0
    }
    
    func getYear(myDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: myDate)
        let year = Int(String(components.year!)) ?? 0
        return year
    }
    
    func printTimestamp() {
        print(Date())
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}


