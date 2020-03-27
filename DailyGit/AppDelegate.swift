//
//  AppDelegate.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/23/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit
import OneSignal
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().tintColor = Constants.gitGreenColor
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    
        initializeOneSignal(launchOptions)
        setupNotifications()
        
        if (userExist() == true) {
            //LoggedIn
            self.window?.rootViewController = MainTabBarController()
        } else {
            //Not Logged In
            let navController = OnboardingVC()
            window?.rootViewController = navController
            let alertController = UIAlertController(title: "Do you want to recieve alerts reminding you to code?", message: "Great! We can notify you.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                //self.registerForPushNotifications(application)
            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        
        return true
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func userExist() -> Bool {
        return (UserInfoHelper.shared.readInfo(info: .username) as? String != "")
    }
    
    func initializeOneSignal(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
        appId: "ef557b26-24b4-4e80-b7b3-e27fa31f4d97",
        handleNotificationAction: nil,
        settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
        print("User accepted notifications: \(accepted)")
        })
        //END OneSignal initializataion code
    }
}

//Handles Notifcations

extension AppDelegate: UNUserNotificationCenterDelegate {
    func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Background")
        print(response.notification.request.content.userInfo)
    }

    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Foreground")
        print(notification.request.content.userInfo)
    }
    
   
}

extension UserDefaults {
    
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
}
