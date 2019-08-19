//
//  Contribution.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/19/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation

struct Contribution: Decodable {
    let date: String
    let count: Int
    //hex color
    let color: String
    let intensity: Int
}
