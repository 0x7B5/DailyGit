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
    
    func stringToDate(myDate: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: myDate)
        
    }
    
    
    func getYear(myDate: String) -> Int {
        let calendar = Calendar.current
        if let date = stringToDate(myDate: myDate){
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            if let year = Int(String(components.year!)) {
                return year
            }
        }
        return 0
    }
    
    func getYear(myDate: Date) -> Int {
         let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: myDate)
        let year = Int(String(components.year!)) ?? 0
        return year
    }
}
