//
//  StatisticsHelper.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/10/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit
public class StatisticsHelper {
    static let shared = StatisticsHelper()
    
    var contributions: ContributionList? {
        get {
            if let contributions = UserInfoHelper.shared.readInfo(info: .contributions) as? ContributionList {
                return contributions
            } else {
                return nil
            }
        }
    }
    
    func daysThisYear() {
        if let conts = UserInfoHelper.shared.readInfo(info: .contributions) as? ContributionList {
            let year = DateHelper.shared.getYear(myDate: Date())
            print("Woah")
            var sum = 1
            var total = 1
            
            for i in conts.contributions {
                print(i)
                if DateHelper.shared.getYear(myDate: i.date, isIso: false) == year {
                    if i.count != 0 {
                        sum += 1
                    }
                    total += 1
                }
            }
            print("You had a GitHub contribution \(sum) days of \(total) days this year.")
        }
    }
    
    #warning("Not sure what to do here")
    
    func weeklyAverage() -> (Double, Double) {
        let thisWeeksAverage: Double = {
            if let weeklyConts = UserInfoHelper.shared.readInfo(info: .currentWeek) as? ContributionList {
                var sum = 0.0
                let count = weeklyConts.contributions.count
                for i in weeklyConts.contributions {
                    sum = sum + Double(i.count)
                }
                
                return (sum/Double(count))
            } else {
                return 1
            }
        }()
        
        let lastWeeksAverage: Double = {
            if let weeklyConts = UserInfoHelper.shared.readInfo(info: .lastWeek) as? ContributionList {
                var sum = 0.0
                let count = weeklyConts.contributions.count
                for i in weeklyConts.contributions {
                    sum = sum + Double(i.count).rounded(toPlaces: 2)
                }
                return (sum/Double(count))
            } else {
                return 1
            }
        }()
        
        if lastWeeksAverage == 0 && thisWeeksAverage == 0 {
            return (thisWeeksAverage.rounded(toPlaces: 2), 0)
        } else if lastWeeksAverage == 0 {
            return (thisWeeksAverage.rounded(toPlaces: 2), 100)
        }
        
        let percentageChange = (100 - ((thisWeeksAverage/lastWeeksAverage) * 100)).rounded(toPlaces: 1) * -1
        
        return (thisWeeksAverage.rounded(toPlaces: 2), percentageChange)
    }
    
    func monthlyAverage() -> (Double, Double) {
        var contributionsCopy: [Contribution]
        if contributions?.contributions != nil {
            contributionsCopy = (contributions?.contributions)!
        } else {
            return (1.0,0.0)
        }
        
        let thisMonthsAverage: Double = {
            if contributions != nil {
                var count = 0
                var sum = 0.0
                for i in contributionsCopy.reversed() {
                    if DateHelper.shared.isInMonth(myDate: i.date) {
                        count = count + 1
                        sum = sum + Double(i.count)
                    } else {
                        break
                    }
                }
                contributionsCopy = Array(contributionsCopy.prefix(upTo:(contributionsCopy.count-count)))
                return sum/Double(count)
                
            } else {
                return 1
            }
        }()
        
        let lastMonthsAverage: Double = {
            if contributions != nil {
                var count = 0
                var sum = 0.0
                for i in contributionsCopy.reversed() {
                    if DateHelper.shared.isInLastMonth(myDate: i.date) {
                        count = count + 1
                        sum = sum + Double(i.count)
                    } else {
                        break
                    }
                }
                return sum/Double(count)
                
            } else {
                return 1
            }
        }()
        
        
        
        if lastMonthsAverage == 0 && thisMonthsAverage == 0 {
            return (thisMonthsAverage.rounded(toPlaces: 2), 0)
        } else if lastMonthsAverage == 0 {
            return (thisMonthsAverage.rounded(toPlaces: 2), 100)
        }
        
        let percentageChange = (100 - ((thisMonthsAverage/lastMonthsAverage) * 100)).rounded(toPlaces: 1) * -1
        
        return (thisMonthsAverage.rounded(toPlaces: 2), percentageChange)
    }
    
    func getColor(commits: Double) -> UIColor {
        if commits == 0 {
            return "#ebedf0".getColor()
        } else if commits <= 5 {
            return "#c6e48b".getColor()
        } else if commits <= 10 {
            return "#7bc96f".getColor()
        } else if commits <= 15 {
            return "#239a3b".getColor()
        }
        return "#196127".getColor()
    }
    
    
    func getPercentColor(num: Double) -> UIColor {
        if num > 0.0 {
            return #colorLiteral(red: 0.1137254902, green: 0.6117647059, blue: 0.3529411765, alpha: 1)
        } else if num < 0.0 {
            return #colorLiteral(red: 0.9069225192, green: 0.298107028, blue: 0.2358772755, alpha: 1)
        } else {
            return "#ebedf0".getColor()
        }
    }
    
    func monthlyDays() -> (Int, Int) {
        if contributions != nil {
            var sum = 0
            for i in contributions!.contributions.reversed() {
                if DateHelper.shared.isInMonth(myDate: i.date) {
                    if i.count > 0 {
                        sum = sum + 1
                    }
                } else {
                    break
                }
            }
            let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: Date())
            
            
            return (sum, Int(calanderDate.day ?? 30))
        } else {
            return (0, 30)
        }
        
    }
    
    func weeklyDays() -> (Int, Int) {
        if let weeklyConts = UserInfoHelper.shared.readInfo(info: .currentWeek) as? ContributionList {
            var sum = 0
            var daysSoFar = 0
            for i in weeklyConts.contributions {
                if i.count > 0 {
                    sum = sum + 1
                }
                daysSoFar += 1
            }
            
            return (sum, daysSoFar)
        } else {
            return (0,7)
        }
        
    }
    
    func weeklyPercent() -> Int {
        if let weeklyConts = UserInfoHelper.shared.readInfo(info: .currentWeek) as? ContributionList {
            var sum = 0.0
            let count = weeklyConts.contributions.count
            for i in weeklyConts.contributions {
                if i.count > 0 {
                    sum = sum + 1
                }
            }
            
            if sum == 0 || count == 0 {
                return 0
            }
           
            return Int((sum/Double(count)).rounded(toPlaces: 2) * 100)
        } else {
            return 0
        }
    }
    
    func monthlyPercent() -> Int {
        if contributions != nil {
            var count = 0
            var sum = 0.0
            for i in contributions!.contributions.reversed() {
                if DateHelper.shared.isInMonth(myDate: i.date) {
                    if i.count > 0 {
                        sum = sum + 1
                    }
                    count = count + 1
                } else {
                    break
                }
            }
            if sum == 0 || count == 0 {
                return 0
            }
            
            return Int((sum/Double(count)).rounded(toPlaces: 2) * 100)
        } else {
            return 0
        }
    }
    
    func getPercentageColor(num: Int) -> UIColor {
        if num == 0 {
            return "#ebedf0".getColor()
        } else if num <= 40 {
            return "#c6e48b".getColor()
        } else if num <= 58 {
            return "#7bc96f".getColor()
        } else if num <= 100 {
            return "#239a3b".getColor()
        }
        return "#ebedf0".getColor()
    }
    
    
    
    
    
}
