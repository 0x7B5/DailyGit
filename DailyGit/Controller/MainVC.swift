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
        //GithubDataManager.shared.getDailyCommits()
        
        let name = "vlad-munteanu"
        //print(GithubDataManager.shared.getGithubSource(username: name))
        
        print(GithubDataManager.shared.getDailyCommits(username: name))
        
        
    }
    
    
}