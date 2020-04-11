//
//  StatisticsHelper.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/10/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
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
    
    #warning("Not sure what to do here")
    static var dailyAverage: Double {
        get {
            //            if contributions != nil {
            //                for i in contributions!.contributions {
            //
            //                }
            //
            //            } else {
            //                return 1
            //            }
            return 1
        }
    }
    
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
        
        
        let percentageChange = (100 - ((thisWeeksAverage/lastWeeksAverage) * 100)).rounded(toPlaces: 2) * -1
        
        print(percentageChange)
        
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
                print(contributionsCopy)
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
                        print(i)
                    } else {
                        print(i)
                        break
                    }
                }
                return sum/Double(count)
                
            } else {
                return 1
            }
        }()
        
        
        let percentageChange = (100 - ((thisMonthsAverage/lastMonthsAverage) * 100)).rounded(toPlaces: 2) * -1
        
        return (thisMonthsAverage.rounded(toPlaces: 2), percentageChange)
    }
    
    
    
}
