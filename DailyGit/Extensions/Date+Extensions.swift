//
//  Date+Extensions.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/27/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
