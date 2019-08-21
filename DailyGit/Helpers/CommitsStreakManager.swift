//
//  CommitsStreakManager.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/19/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation

public class CommitsStreakManager {
    static let shared = CommitsStreakManager()
    //private init() { }
    
    func getCurrentStreak() {
        let currentContributions = ReadUserInfoHelper.shared.readInfo(info: .contributions) as? ContributionList
        let date = GithubDataManager.shared.getFormattedDate()
        
        var counter = 0
        var countingYet = false
        
        for i in currentContributions!.contributions {
            if countingYet {
                if i.count > 0 {
                    counter += 1
                } else {
                    break
                }
            } else if i.date == date {
                countingYet = true
            }
        }
        print(counter)
    }
    
    func getLongestStreak() {
        let currentContributions = ReadUserInfoHelper.shared.readInfo(info: .contributions) as? ContributionList
        
        
        var counter = 0
        var maxStreaks = 0
        
        for i in currentContributions!.contributions {
            print(i)
                if i.count > 0 {
                    counter += 1
                    //print(i.date + "\\\\\(i.count)")
                } else {
                    if counter > maxStreaks {
                        maxStreaks = counter
                    }
                    counter = 0
                    //print("---------------------------")
                }
        }
        print("Longest Streak: ", maxStreaks)
    }
    
    
}
