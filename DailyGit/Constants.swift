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
    static let subTitleColor = UIColor(named: "subTitleTextColor")
    static let titleColor = UIColor(named: "titleTextColor")
    static let blueColor = #colorLiteral(red: 0.1098039216, green: 0.4666666667, blue: 0.8941176471, alpha: 1)
    static let whiteColor = #colorLiteral(red: 0.9685223699, green: 0.9686879516, blue: 0.9685119987, alpha: 1)
    
    // Other stuff
    static var profaneNotications = false
    static var isIpad = false
    static var sessionID = "com.LesGarcons.DailyGit"
    
    #warning("This needs to be able to be changed by the user")
    static var numberOfNotificationsPerDay = 24
    
    
   static var darkMode = false 
    
    
}

