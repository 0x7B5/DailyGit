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
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year = String(components.year!)
        var month = String(components.month!)
        var day = String(components.day!)
        
        if components.month! < 10 {
            month = "0" + String(components.month!)
        }
        
        if components.day! < 10 {
            day = "0" + String(components.month!)
        }
        
        let currentDate = "\(year)-\(month)-\(day)"
        return currentDate
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
    
    func getDayOfWeek(fromDate date: Date) -> Int {
        let cal = Calendar(identifier: .gregorian)
        let dayOfWeek = cal.component(.weekday, from: date)
        
        if dayOfWeek != nil {
            return dayOfWeek - 1
        }
        return 0

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
    
    func getDaysOfWeek() -> [String] {
        
        var myDateArray = [String]()
        let currentDate = getFormattedDate()
        
        return myDateArray
        
    }
}
