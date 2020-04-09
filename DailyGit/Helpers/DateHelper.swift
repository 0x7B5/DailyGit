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
    
    func getLastUpdatedText(myDate: Date) -> String {
        var dayUpdated = ""
        var timeOfDay = "AM"
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.day, .weekday, .hour, .minute], from: myDate)
        var hour = comp.hour ?? 0
        
        if hour >= 12 {
            timeOfDay = "PM"
        }
        
        if hour != 12 {
            hour = hour % 12
        }
        let minute = comp.minute ?? 0
        
        if calendar.isDateInToday(myDate) {
            dayUpdated = "Today"
        } else if calendar.isDateInYesterday(myDate) {
            dayUpdated = "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: myDate)
            let yourDate = formatter.date(from: myString)
            formatter.dateFormat = "dd-MMM"
            dayUpdated = formatter.string(from: yourDate!)
        }
        
        let timeUpdated = String(format: "%02d:%02d", hour, minute)
        
        return "Last updated " + dayUpdated + " at " + timeUpdated + " " + timeOfDay
    }
    
    func canRefreshUserInfo() -> Bool {
        if let lastUpdated = UserInfoHelper.shared.readInfo(info: .userUpdateTime) as? Date {
            let rn = Date()
            let minutes = rn.minutes(from: lastUpdated)
            if minutes < 2 {
                return false
            }
        }
        return true
    }
    
    func timeElapsedInSecondsWhenRunningCode(operation: ()->()) -> Double {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return Double(timeElapsed)
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

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

