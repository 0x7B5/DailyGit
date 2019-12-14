//
//  Constants.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/23/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit

public struct Constants {
    static var darkMode = false
    static let gitGreenColor = #colorLiteral(red: 0.1026554033, green: 0.3837691247, blue: 0.1535629034, alpha: 1)
    static var navBarColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static var tabBarColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static var profaneNotications = false
    
    static var isIpad = false
    
    #warning("This needs to be able to be changed by the user")
    static var numberOfNotificationsPerDay = 24
}

