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
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            Constants.isIpad = true
        }
        
        //resetDefaults()
        
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        UINavigationBar.appearance().isTranslucent = false
        
//        Launchscreen Jaunt
//        do {
//            try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
//        } catch {
//            print("Failed to delete launch screen cache: \(error)")
//        }
        
        UITabBar.appearance().tintColor = Constants.gitGreenColor
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        setupNotifications()
        
        if (userExist() == true) {
            //LoggedIn
            UserInfoHelper.shared.refreshEverything {
                
            }
            AutoUpdater.shared.startTimer()
            
            let navigationController = UINavigationController(rootViewController: MainVC())
            self.window?.rootViewController = navigationController
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        AutoUpdater.shared.stopTimer()
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        AutoUpdater.shared.stopTimer()
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
