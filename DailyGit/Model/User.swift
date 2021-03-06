//
//  User.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/19/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: String
    var username: String
    var bio: String
    //gotta store that on user device
    var photoUrl: String
    var contributions: ContributionList
    var updateTime: Date
    var userUpdateTime: Date
    var lastWeek: ContributionList {
        get {
            var randContList = [Contribution?](repeating: nil, count: 6)
            let offset = currentWeek.contributions.count
            for element in contributions.contributions.reversed()[offset...] {
                randContList.insert(element, at: element.dayOfWeek)
                if(element.dayOfWeek == 0) {
                    break
                }
            }
            return ContributionList(contributions: randContList.compactMap { $0 })
        }
    }
    
    var longestStreak: Int {
        get {
            var counter = 0
            var maxStreaks = 0
            
            for i in contributions.contributions {
                if i.count > 0 {
                    counter += 1
                } else {
                    if counter > maxStreaks {
                        maxStreaks = counter
                    }
                    counter = 0
                }
            }
            if counter > maxStreaks {
                maxStreaks = counter
            }
            return maxStreaks
        }
    }
    var currentStreak: Int {
        get {
            var date = DateHelper.shared.getFormattedDate()
            
            if let myLast = contributions.contributions.last {
                if myLast.count == 0 {
                    date = DateHelper.shared.getYesterdayDate()
                }
                
                var counter = 0
                var countingYet = false
                
                for i in contributions.contributions.reversed() {
                    if countingYet {
                        if i.count > 0 {
                            counter += 1
                        } else {
                            break
                        }
                    }
                    
                    if i.date == date {
                        countingYet = true
                        if i.count > 0 {
                            counter += 1
                        }
                    }
                }
                return counter
            } else {
                return 0
            }
            
            
        }
    }
    var dateCreated: String
    var yearCreated: Int
    
    
    var currentWeek: ContributionList {
        get {
            var randContList = [Contribution?](repeating: nil, count: 6)
            for element in contributions.contributions.reversed() {
                randContList.insert(element, at: element.dayOfWeek)
                if(element.dayOfWeek == 0) {
                    break
                }
            }
            return ContributionList(contributions: randContList.compactMap { $0 })
        }
    }
    
    var currentMonth: ContributionList {
        get {
            var randContList = [Contribution]()
            for element in contributions.contributions.reversed() {
                if DateHelper.shared.isInMonth(myDate: element.date) {
                    randContList.append(element)
                } else {
                    break
                }
            }
            
            var temp = [Contribution]()
            for i in randContList.reversed() {
                temp.append(i)
            }
            
            return ContributionList(contributions: temp.compactMap { $0 })
        }
    }
    
    var lastMonth: ContributionList {
        get {
            var randContList = [Contribution]()
            var contributionsCopy = contributions.contributions
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
            
            for i in contributionsCopy.reversed() {
                if DateHelper.shared.isInLastMonth(myDate: i.date) {
                    randContList.append(i)
                } else {
                    break
                }
            }
            
            var temp = [Contribution]()
            for i in randContList.reversed() {
                temp.append(i)
            }
            
            return ContributionList(contributions: temp.compactMap { $0 })
        }
    }
    
    init (name: String, username: String, bio: String, photoUrl: String, dateCreated: String, yearCreated: Int, contributions: ContributionList) {
        self.name = name
        self.username = username
        self.bio = bio
        self.photoUrl = photoUrl
        self.contributions = contributions
        self.dateCreated = dateCreated
        self.yearCreated = yearCreated
        self.updateTime = Date()
        self.userUpdateTime = Date()
    }
    
}
