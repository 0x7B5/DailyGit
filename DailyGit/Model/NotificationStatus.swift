//
//  NotificationStatus.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/25/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation

struct NotificationStatus: Codable {
    var notificationsEnabled: Bool?
    var date: Date?
    var times: Int?
}
