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
        let mainVC = MainVC()
        //all the cool kids have no titles for their tab bars
        mainVC.tabBarItem.title = ""
        mainVC.tabBarItem.image = UIImage(named: "settingsIcon")
        
        let settingsVC = SettingsVC()
        settingsVC.tabBarItem.title = ""
        settingsVC.tabBarItem.image = UIImage(named: "codeIcon")
        
        let controllers = [mainVC, settingsVC]
        self.viewControllers = controllers
    }


}

