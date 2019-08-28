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
        
        print(currentDate)
        return currentDate
    }
    
    func stringToDate(date: String) -> Date {
        print(date)
        #warning("somethig")
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:date)!
        
        return date
    }
    
    func getYear(myDate: String) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: stringToDate(date: myDate))
        
        if let year = Int(String(components.year!)) {
            return year
        } else {
            return 0
        }
    }
}
