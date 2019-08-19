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
    
    init (name: String, username: String, bio: String, photoUrl: String, contributions: ContributionList) {
        self.name = name
        self.username = username
        self.bio = bio
        self.photoUrl = photoUrl
        self.contributions = contributions
    }
}
