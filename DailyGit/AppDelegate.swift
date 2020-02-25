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
        return (ReadUserInfoHelper.shared.readInfo(info: .username) as? String != "")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().tintColor = Constants.gitGreenColor
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        UNUserNotificationCenter.current().delegate = self
        
        
        if (userExist() == true) {
            //LoggedIn
            self.window?.rootViewController = MainTabBarController()
            self.handleNotifications()
            
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
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
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
        print("We still outchea")
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
                        
                        
                        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0*60.0, repeats: true)
                        
                        
                        
                        
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
