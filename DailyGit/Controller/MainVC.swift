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
        updateInfo()
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
    
    func updateInfo() {
        UserInfoHelper.shared.refreshEverything(completion: {
            DispatchQueue.main.async { () -> Void in
                let name = (UserInfoHelper.shared.readInfo(info: .name) as? String ?? "")
                if name.count > 15 {
                    let nameSubString = String(name[...15])
                    self.mainView.topView.nameLabel.text = nameSubString
                } else {
                    self.mainView.topView.nameLabel.text = name
                }
                
                self.mainView.topView.bioLabel.text = (UserInfoHelper.shared.readInfo(info: .bio) as? String ?? "")
                self.mainView.todayView.setNumberLabels()
                self.mainView.setLastUpdatedLabel()
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
    }
    
}


