//
//  User.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/19/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: String
    let username: String
    let bio: String
    //gotta store that on user device
    let photoUrl: String
    let contributions: ContributionList
    
    let longestStreak: Int
    let currentStreak: Int
    let dateCreated: String
    
    
    /*
     Contributions is organized with oldest date first
     -------------------------------------------------
     Reversed, newest date first
     
     */
    
    lazy var currentWeek: ContributionList = {
        var counting = false
        var randContList = [Contribution]()
        
        for (index, element) in contributions.contributions.reversed().enumerated() {
            if element.date == DateHelper.shared.getFormattedDate() {
                //counting = true
                let psedoIndex = contributions.contributions.count - index-1
                if element.dayOfWeek == 0 {
                    for x in 0...6 {
                        randContList.append(contributions.contributions[psedoIndex + x])
                    }
                } else if element.dayOfWeek == 6 {
                    for x in stride(from: 6, to: -1, by: -1) {
                        randContList.append(contributions.contributions[psedoIndex - x])
                    }
                } else {
                    for x in 0...6 {
                        randContList.append(contributions.contributions[psedoIndex - element.dayOfWeek + x])
                    }
                }
                break
            }
        }
        return ContributionList(contributions: randContList)
        
    }()
    
    #warning("We'll have to update this.")
    
    init (name: String, username: String, bio: String, photoUrl: String, dateCreated: String, contributions: ContributionList) {
        self.name = name
        self.username = username
        self.bio = bio
        self.photoUrl = photoUrl
        self.contributions = contributions
        self.longestStreak = 0
        self.currentStreak = 0
        self.dateCreated = dateCreated
        #warning("Clean this up")
        print(self.currentWeek)
    }
    
    
    
}
