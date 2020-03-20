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
        self.mainView.profileImage.layer.cornerRadius = self.mainView.profileImage.frame.size.width/2
        self.mainView.profileImage.layer.masksToBounds = true
        self.mainView.profileImage.layer.borderColor = UIColor.clear.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.checkAllignmentForTitle()
        setupInfo()
    }
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()
        if Constants.isIpad == true {
            print("iPad")
        }
    }
    
    func setupInfo() {
        ReadUserInfoHelper.shared.getCurrentStreak()
        ReadUserInfoHelper.shared.getLongestStreak()
        
        mainView.nameLabel.text = (ReadUserInfoHelper.shared.readInfo(info: .name) as! String)
        mainView.bioLabel.text = (ReadUserInfoHelper.shared.readInfo(info: .bio) as! String)
        self.mainView.dailyCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "DailyCommits"))
        self.mainView.currentStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "CurrentStreak")) + " days 🔥"
        self.mainView.longestStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "LongestStreak")) + " days 🔥"
        self.mainView.setupColorsForWeek(contributions: ReadUserInfoHelper.shared.readInfo(info: .currentWeek) as! ContributionList)
        updateInfo()
    }
    
    
    func updateInfo() {
        ReadUserInfoHelper.shared.refreshEverything(completion: {
            DispatchQueue.main.async { () -> Void in
                self.mainView.dailyCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "DailyCommits"))
                self.mainView.currentStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "CurrentStreak")) + " days 🔥"
                self.mainView.longestStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "LongestStreak")) + " days 🔥"
                self.mainView.setupColorsForWeek(contributions: ReadUserInfoHelper.shared.readInfo(info: .currentWeek) as! ContributionList)
            }
            
        })
        
    }
    
    
    
    func setupNavController() {
        self.title = "Commits"
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
      //  print(ReadUserInfoHelper.shared.getYearlyContributionsDates())
    }
    
}


