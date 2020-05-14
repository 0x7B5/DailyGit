//
//  GenericData.swift
//  WatchDailyGit Extension
//
//  Created by Vlad Munteanu on 5/13/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation

struct GenericData: Codable {
    var username: String
    var commitsToday: Int
    var commitsYesterday: Int
    var currentStreak: Int
    
    init(username: String, commitsToday: Int, commitsYesterday: Int, currentStreak: Int) {
        self.username = username
        self.commitsToday = commitsToday
        self.commitsYesterday = commitsYesterday
        self.currentStreak = currentStreak
    }
}
