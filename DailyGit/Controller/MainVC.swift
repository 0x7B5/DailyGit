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
    //lazy var mainView = CommitsView(topLayout: self.navigationController!.navigationBar.frame.height)
    lazy var mainView = CommitsView()
    
    override func viewDidLayoutSubviews() {
        
        #warning("Fix not rounded profile picture")
        self.mainView.topView.subviews[0].layer.cornerRadius = self.mainView.topView.subviews[0].frame.size.width/2
        self.mainView.topView.subviews[0].layer.masksToBounds = true
        self.mainView.topView.subviews[0].layer.borderColor = UIColor.clear.cgColor
        
        
        for view in self.mainView.topView.subviews as [UIView] {
            if view.tag == 0 {
//                view.layer.cornerRadius = view.frame.size.width/2
//                view.layer.masksToBounds = true
//                view.layer.borderColor = UIColor.clear.cgColor
            } else if view.tag == 2 {
                view.sizeToFit()
            }
        }
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
        UserInfoHelper.shared.getCurrentStreak()
        UserInfoHelper.shared.getLongestStreak()
        
        mainView.nameLabel.text = ((UserInfoHelper.shared.readInfo(info: .name) as! String).substring(to: 15))
        mainView.bioLabel.text = (UserInfoHelper.shared.readInfo(info: .bio) as! String)
        self.mainView.dailyCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "DailyCommits"))
        self.mainView.currentStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "CurrentStreak")) + " days 🔥"
        self.mainView.longestStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "LongestStreak")) + " days 🔥"
        self.mainView.setupColorsForWeek(contributions: UserInfoHelper.shared.readInfo(info: .currentWeek) as! ContributionList)
        updateInfo()
    }
    
    
    func updateInfo() {
        UserInfoHelper.shared.refreshEverything(completion: {
            DispatchQueue.main.async { () -> Void in
                self.mainView.dailyCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "DailyCommits"))
                self.mainView.currentStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "CurrentStreak")) + " days 🔥"
                self.mainView.longestStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "LongestStreak")) + " days 🔥"
                self.mainView.setupColorsForWeek(contributions: UserInfoHelper.shared.readInfo(info: .currentWeek) as! ContributionList)
            }
            
        })
        
    }
    
    
    
    func setupNavController() {
        self.title = "Contributions"
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
      //  print(UserInfoHelper.shared.getYearlyContributionsDates())
    }
    
}


