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
    
    override func viewDidLayoutSubviews() {
        self.mainView.bioLabel.sizeToFit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.checkAllignmentForTitle()
    }
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
    }
    
    func setupInfo() {
        mainView.nameLabel.text = (ReadUserInfoHelper.shared.readInfo(info: .name) as! String)
        mainView.bioLabel.text = (ReadUserInfoHelper.shared.readInfo(info: .bio) as! String)
        updateInfo()
    }
    
    func updateInfo() {
        ReadUserInfoHelper.shared.refreshEverything(completion: {
            self.mainView.dailyCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "DailyCommits"))
            self.mainView.currentStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "CurrentStreak")) + " days 🔥"
            self.mainView.longestStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "LongestStreak")) + " days 🔥"
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
        if Reachability.shared.isConnectedToNetwork() {
            updateInfo()
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}


