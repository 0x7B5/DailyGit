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
    // Colors
    static let gitGreenColor = #colorLiteral(red: 0.1026554033, green: 0.3837691247, blue: 0.1535629034, alpha: 1)
    static let mainBGColor = UIColor(named: "mainBackgroundColor")
    static let subTitleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.599609375)
    static let titleColor = UIColor(named: "titleTextColor")
    static let blueColor = #colorLiteral(red: 0.1098039216, green: 0.4666666667, blue: 0.8941176471, alpha: 1)
    static let whiteColor = #colorLiteral(red: 0.8669320599, green: 0.8755155457, blue: 0.8755155457, alpha: 1)
    
    // Other stuff
    static var profaneNotications = false
    static var isIpad = false
    static var sessionID = "com.LesGarcons.DailyGit"
    
    #warning("This needs to be able to be changed by the user")
    static var numberOfNotificationsPerDay = 24
    
    static var profileImageWidth: CGFloat = 0.18
    
    static var screenWidth: CGFloat {
        get {
            return UIScreen.main.bounds.size.width
        }
    }
    
    static var screenHeight: CGFloat {
        get {
            return UIScreen.main.bounds.size.height
        }
    }
    
    static var refreshRatePerSecond = 10
    
    static var timerStatus: Bool {
        get {
            if AutoUpdater.shared.timer == nil {
                return false
            }
            return true
        }
    }
    
    static var streakStatus: StreakStatus = .current
    
}

