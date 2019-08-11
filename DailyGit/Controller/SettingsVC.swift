//
//  SettingsVC.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/28/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    let mainView = SettingsView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()
        
    }
    
    func setupNavController() {
        self.title = "Settings"
        self.navigationController?.navigationBar.barTintColor = Constants.navBarWhite
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.gitGreenColor]
    }
}
