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
    
    var longestStreak: Int
    var currentStreak: Int
    var dateCreated: String
    
    
    var currentWeek: ContributionList
    
    #warning("We'll have to update this.")
    
    init (name: String, username: String, bio: String, photoUrl: String, dateCreated: String, contributions: ContributionList, currentWeek: ContributionList) {
        self.name = name
        self.username = username
        self.bio = bio
        self.photoUrl = photoUrl
        self.contributions = contributions
        self.longestStreak = 0
        self.currentStreak = 0
        self.dateCreated = dateCreated
        self.currentWeek = currentWeek
    }
    
    
    
}
