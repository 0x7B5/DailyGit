//
//  MainVC.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/28/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    
    
    #warning("Kind of hacky and potentially dangerous")
    lazy var mainView = CommitsView(topLayout: self.navigationController!.navigationBar.frame.height)
    
    override func loadView() {
        self.view = mainView
        setupInfo()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()
        if Constants.isIpad == true {
            print("iPad")
        }
      CommitsStreakManager.shared.getCurrentStreak()
        CommitsStreakManager.shared.getLongestStreak()
    }
    
    func setupInfo() {
        mainView.nameLabel.text = (ReadUserInfoHelper.shared.readInfo(info: .name) as! String)
        mainView.bioLabel.text = (ReadUserInfoHelper.shared.readInfo(info: .bio) as! String)
        
       ReadUserInfoHelper.shared.getDailyCommits(completion: {
            commits in
            DispatchQueue.main.async { [weak self] in
                self!.mainView.dailyCommitsLabel.text = String(commits)
            }
        })
        
    }
    
    func setupNavController() {
        self.title = "Commits"
    //self.navigationController?.navigationBar.barTintColor = Constants.navBarColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.gitGreenColor]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refresh))
    }
    
    @objc func refresh() {
        print("refresh")
       ReadUserInfoHelper.shared.getDailyCommits(completion: {
            commits in
            DispatchQueue.main.async { [weak self] in
                print("Commits")
                self!.mainView.dailyCommitsLabel.text = String(commits)
            }
        })
    }
    
}
