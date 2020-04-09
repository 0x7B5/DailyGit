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
    }
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()
        updateInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(autoRefresher), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
    }
    
    func updateInfo() {
        UserInfoHelper.shared.refreshEverything(completion: {
            DispatchQueue.main.async { () -> Void in
                print("1")
                self.updateUI()
            }
        })
        
    }
    
    func updateUI() {
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
    
    @objc func autoRefresher(notification: NSNotification) {
        updateInfo()
    }
    
    
    
    func setupNavController() {
        self.title = "Contributions"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.gitGreenColor]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refresh))
    }
    
    @objc func refresh() {
        print("refresh")
        if Reachability.shared.isConnectedToNetwork() {
//            let methodStart = Date()
//            UserInfoHelper.shared.refreshEverything(completion: {
//                let methodFinish = Date()
//                let executionTime = methodFinish.timeIntervalSince(methodStart)
//                print("Execution time: \(executionTime)")
//            })
            updateInfo()
            print("")
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}


