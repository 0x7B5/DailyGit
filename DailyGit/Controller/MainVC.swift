//
//  MainVC.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/28/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    lazy var mainView = CommitsView()
    unowned var topView: UIView { return mainView.topView}
    
    override func viewDidLayoutSubviews() {
        mainView.topView.profileImage.makeRounded(frameSize: self.mainView.topView.frame.width)
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
        
        let name = (UserInfoHelper.shared.readInfo(info: .name) as? String ?? "")
        if name.count > 15 {
            let nameSubString = String(name[...15])
            mainView.topView.nameLabel.text = nameSubString
        } else {
            mainView.topView.nameLabel.text = name
        }
        
        mainView.topView.bioLabel.text = (UserInfoHelper.shared.readInfo(info: .bio) as? String ?? "")
        //self.mainView.dailyCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "DailyCommits"))
        //self.mainView.currentStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "CurrentStreak")) + " days 🔥"
        //self.mainView.longestStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "LongestStreak")) + " days 🔥"
        //self.mainView.setupColorsForWeek(contributions: UserInfoHelper.shared.readInfo(info: .currentWeek) as! ContributionList)
        updateInfo()
    }
    
    
    func updateInfo() {
        UserInfoHelper.shared.refreshEverything(completion: {
            DispatchQueue.main.async { () -> Void in
                #warning("Check why this is updating ui when setupInfo already does")
                //self.mainView.dailyCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "DailyCommits"))
                // self.mainView.currentStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "CurrentStreak")) + " days 🔥"
                // self.mainView.longestStreakCommitsLabel.text = String(UserDefaults.standard.integer(forKey: "LongestStreak")) + " days 🔥"
                // self.mainView.setupColorsForWeek(contributions: UserInfoHelper.shared.readInfo(info: .currentWeek) as! ContributionList)
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


