//
//  Contribution.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/19/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation

enum ContributionColor: String {
    case noCommits = "ebedf0"
    case lightCommits = "c6e48b"
    case mediumCommits = "7bc96f"
    case strongCommits = "239a3b"
}

struct ContributionList: Codable {
    let contributions: [Contribution]
}

struct Contribution: Codable {
    let date: String
    let count: Int
    //hex color
    let color: String
    let dayOfWeek: Int
    //let intensity: Int
}
