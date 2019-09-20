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
            print(element)
            if element.date == DateHelper.shared.getFormattedDate() {
                //counting = true
                print("dayOF THE WEEK \(element.dayOfWeek)")
                let psedoIndex = contributions.contributions.count - index
                if element.dayOfWeek == 0 {
                    for x in 0...7 {
                        randContList.append(contributions.contributions[psedoIndex + x])
                        print()
                    }
                } else if element.dayOfWeek == 7 {
                    for x in stride(from: 7, to: 0, by: -1) {
                        randContList.append(contributions.contributions[psedoIndex + x])
                    }
                }
            }
        }
        return contributions
        
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
