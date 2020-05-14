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
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    // Outlets
    // To set invaliable, set font lower size, horizontal left, allignment left, lines 0
    
    @IBOutlet weak var warningLabel: WKInterfaceLabel!
    @IBOutlet weak var commitsLabel: WKInterfaceLabel!
    @IBOutlet weak var contributionsTodayLabel: WKInterfaceLabel!
    @IBOutlet weak var divider: WKInterfaceSeparator!
    @IBOutlet weak var streakLabel: WKInterfaceLabel!
    @IBOutlet weak var currentStreakLabel: WKInterfaceLabel!
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("AW Connecting")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("hey ifone")
        if let username = message["username"] as? String, let creationYear = message["creationYear"] as? String {
            if let defUsername = DataGetter.shared.readInfo(info: .username) as? String {
                if defUsername != username {
                    setupUser(username: username, creationYear: creationYear)
                }
                DataGetter.shared.updateInfo(completion: {
                    print("finished")
                    print("Done")
                    self.refreshUI()
                })
            } else {
                setupUser(username: username, creationYear: creationYear)
                refreshUI()
            }
        }
    }
    
    func setupUser(username: String, creationYear:String) {
        let newUser = GenericData(username: username, commitsToday: 0, commitsYesterday: 0, currentStreak: 0, creationYear: Int(creationYear) ?? 2018)
        DataGetter.shared.updateUserInDefaults(dataToEncode: newUser)
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if DataGetter.shared.isThereData() {
            if let commitsToday = DataGetter.shared.readInfo(info: .commitsToday) as? Int, let currentStreak = DataGetter.shared.readInfo(info: .currentStreak) as? Int {
                commitsLabel.setText(String(commitsToday))
                streakLabel.setText(String(currentStreak))
            } else {
                commitsLabel.setText(String(0))
                streakLabel.setText(String(0))
            }
            
            DataGetter.shared.updateInfo(completion: {
                print("finished")
                self.refreshUI()
            })
            
        } else {
            hideShit()
        }
        
    }
    
    func refreshUI() {
        print("refresh")
        if DataGetter.shared.isThereData() {
            warningLabel.setHidden(true)
            contributionsTodayLabel.setHidden(false)
            divider.setHidden(false)
            streakLabel.setHidden(false)
            currentStreakLabel.setHidden(false)
            commitsLabel.setHidden(false)

            if let commitsToday = DataGetter.shared.readInfo(info: .commitsToday) as? Int, let currentStreak = DataGetter.shared.readInfo(info: .currentStreak) as? Int {
                commitsLabel.setText(String(commitsToday))
                streakLabel.setText(String(currentStreak))
            } else {
                commitsLabel.setText(String(0))
                streakLabel.setText(String(0))
            }
            
            
        }
    }
    
    func hideShit() {
        contributionsTodayLabel.setHidden(true)
        divider.setHidden(true)
        streakLabel.setHidden(true)
        currentStreakLabel.setHidden(true)
        commitsLabel.setHidden(true)
        warningLabel.setHidden(false)
        
        warningLabel.setText("Setup user on iPhone to use the Apple Watch app.")
    }
    
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        refreshUI()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
