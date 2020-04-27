//
//  InterfaceController.swift
//  WatchDailyGit Extension
//
//  Created by Vlad Munteanu on 12/26/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//


//Since watchOS2, you don't have any built in function for communicating between the iOS and watchOS app other than the WatchConnectivity framework. Due to the fact that Watch apps are no longer considered App Extensions, they don't have access to AppGroups and hence to UserDefaults on the iPhone.
//
//For syncing UserDefaults, the updateApplicationContext(_:) function seems to be the best solution. You can send a dictionary of data with this function (the data you just saved to UserDefaults on the iPhone) and the system tries to make sure that the data is received by the time your app is displayed to the user. If the function is called several times before the app would be visible to the user (run in the foreground), the system overwrites the previous data, so the Watch app only receives the most recent data to display.

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        let lastWeek = UserInfoHelper.shared.readInfo(info: .lastWeek)
        
        
        print(lastWeek)
        print("AW we out here")
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBOutlet weak var commitsLabel: WKInterfaceLabel!
}
