//
//  MainVC.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/28/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()

        let name = "vlad-munteanu"
        //print(GithubDataManager.shared.getGithubSource(username: name))
        
        print(GithubDataManager.shared.getDailyCommits(username: name))
        print(GithubDataManager.shared.isValidUser(username: name))
    }
    
    func setupNavController() {
           self.title = "Commits"
           self.navigationController?.navigationBar.barTintColor = Constants.navBarColor
           self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.gitGreenColor]
       }
    
}
