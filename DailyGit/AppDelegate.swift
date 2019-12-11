//
//  AppDelegate.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/23/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func userExist() -> Bool {
        if (ReadUserInfoHelper.shared.readInfo(info: .username) as? String != "") {
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().tintColor = Constants.gitGreenColor
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //resetDefaults()
        
        UNUserNotificationCenter.current().delegate = self
        
        
        if (userExist() == true) {
            //LoggedIn
            self.handleNotifications()
            self.window?.rootViewController = MainTabBarController()
        } else {
            //Not Logged In
            let navController = UINavigationController(rootViewController: OnboardingVC())
            window?.rootViewController = navController
            let alertController = UIAlertController(title: "Do you want to recieve daily alerts reminding you to commit?", message: "Great! We can notify you.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                self.registerForPushNotifications()
            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        
        #warning("Have to present our own custom alert first here")
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if(UserDefaults.standard.object(forKey: "CurrentUser") != nil) {
            #warning("Have to fix data flow")
            //ReadUserInfoHelper.shared.refreshEverything(completion: {
                
           // })
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

//Handles Notifcations

extension AppDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("idk")
        completionHandler()
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted: \(granted)")
        }
    }
    
    func handleNotifications() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
                self.registerForPushNotifications()
            } else if settings.authorizationStatus == .denied {
                // Notification permission was previously denied, go to settings & privacy to re-enable
                return
            } else if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                
                
                if(UserDefaults.standard.object(forKey: "CurrentUser") != nil) {
                    
                    ReadUserInfoHelper.shared.refreshEverything {
                        //LoggedIn
                        let content = UNMutableNotificationContent()
                        content.sound = UNNotificationSound.default
                        
                        var trigger: UNTimeIntervalNotificationTrigger
                        
                        
                        #warning("Fix logic here, this repeats every hour from when app is installed, not from the exact hour time as it should")
                        // Right now this is
                        // Just repeating every hour
                      //  let  trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0, repeats: true)
                        
                        if Constants.numberOfNotificationsPerDay <= 24 && Constants.numberOfNotificationsPerDay != 0 {
                            
                          
                           // trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0*60.0, repeats: true)
                            
                     
                        } else {
                            //set it once a day
//                            var dateComponents = DateComponents()
//                            dateComponents.hour = 10
//                            dateComponents.minute = 00
//
//                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                            
                            //trigger = UNTimeIntervalNotificationTrigger(timeInterval: (60*60*24)/2.0, repeats: true)

                        }
                        
                        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0*60.0, repeats: true)
                        
                        
                        let commitsCount = UserDefaults.standard.integer(forKey: "DailyCommits")
                        
                        switch commitsCount {
                        case 0:
                            content.title = "Work Harder"
                            content.body = "No commits today, go code."
                        case 1:
                            content.title = "Keep it up!"
                            content.body = "\(commitsCount) contribution so far today."
                        case 2...3:
                            content.title = "Keep it up!"
                            content.body = "\(commitsCount) contributions so far today."
                        case 4...9:
                            content.title = "Good Job!"
                            content.body = "\(commitsCount) contributions so far today."
                        case 10...19:
                            content.title = "You're killing it!"
                            content.body = "\(commitsCount) contributions so far today."
                        case 20...:
                            content.title = "You're a beast!"
                            content.body = "\(commitsCount) contributions so far today."
                        default:
                            content.title = "Keep it up!"
                            content.body = "\(commitsCount) contributions so far today."
                        }
                        
                        
                        let uuidString = UUID().uuidString
                        
                        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                        
                        
                        
                        
                        // Schedule the request with the system.
                        let notificationCenter = UNUserNotificationCenter.current()
                        notificationCenter.removeAllPendingNotificationRequests()
                        notificationCenter.add(request, withCompletionHandler: nil)
                        
                        //notificationCenter.removeAllPendingNotificationRequests()
                 
                    }
                    
                    
                } else {
                    return
                }
                
                
            }
        })
    }
}

extension UserDefaults {

    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

}
