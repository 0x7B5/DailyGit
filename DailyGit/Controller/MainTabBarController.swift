//
//  MainTabBarController.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/23/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 12.0, *) {
            switch UIScreen.main.traitCollection.userInterfaceStyle {
            case .light:
                Constants.darkMode = false
            case .dark:
                Constants.darkMode = true
            case .unspecified:
                Constants.darkMode = true
            @unknown default:
                Constants.darkMode = true
            }
        } else {
           Constants.darkMode = true
        }
        
        //check what device
        if (self.view.frame.width >= 700 ) {
            Constants.isIpad = true
        }
        
        let mainVC = MainVC()
    
        mainVC.tabBarItem.title = "Dashboard"
        mainVC.tabBarItem.image = UIImage(named: "codeIcon")
        
        let settingsVC = RootSettingVC()
        settingsVC.tabBarItem.title = "Search"
        settingsVC.tabBarItem.image = UIImage(named: "settingsIcon")
        
        let controllers = [mainVC, settingsVC]
        self.viewControllers = controllers.map{ UINavigationController.init(rootViewController: $0)}
    }
    
    
}

