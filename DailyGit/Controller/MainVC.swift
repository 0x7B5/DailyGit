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
    unowned var todayView: TodaySubView { return mainView.todayView}
    
    override func viewDidLayoutSubviews() {
        mainView.topView.profileImage.makeRounded(frameSize: self.mainView.topView.frame.width)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
        updateInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
        updateInfo()
    }
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestures()
        StatisticsHelper.shared.monthlyAverage()
        setupNavController()
        updateUI()
        updateInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(autoRefresher), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
    }
    
    func updateInfo() {
        UserInfoHelper.shared.refreshEverything(completion: {
            DispatchQueue.main.async { () -> Void in
                self.updateUI()
            }
        })
        
    }
    
    func addTapGestures() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(changeStreak))
//        self.todayView.addGestureRecognizer(tap)
//        self.todayView.currentStreak.addGestureRecognizer(tap)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
            let position = firstTouch.location(in: view)
            if hitView === self.todayView {
                handleTodayViewTouches(place: position)
            } else {
                
            }
        }
    }
    
    func handleTodayViewTouches(place: CGPoint) {
        let tempWidth = todayView.frame.width - todayView.frame.minX
        if place.x < tempWidth/3 {
            print("Yesterday")
        } else if place.x > tempWidth/3 && place.x < ((tempWidth/3) * 2) {
            print("Today")
        } else if place.x > ((tempWidth/3) * 2) {
            mainView.changeStreak()
        }
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
        self.mainView.lastWeekView.setupColorsForWeek()
        self.mainView.weekView.setupColorsForWeek()
        self.mainView.updateStatistics()
    }
    
    @objc func autoRefresher(notification: NSNotification) {
        updateInfo()
    }
    
    
    
    func setupNavController() {
        self.title = "Contributions"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.gitGreenColor]
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "refreshLogo"), for: .normal)
        button.addTarget(self, action:#selector(refresh), for: .touchDragInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
        
        let settingsBarItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(goToSettings))
        settingsBarItem.tintColor = Constants.subTitleColor
        navigationItem.rightBarButtonItem = settingsBarItem
    }
    
    @objc func goToSettings() {
        let nextViewController = RootSettingVC()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func refresh() {
        print("refresh")
        
        if Reachability.shared.isConnectedToNetwork() {
            if let button = self.navigationItem.leftBarButtonItems?[0] {
                button.customView?.rotate360Degrees()
            }
            if UserInfoHelper.shared.currentState == .goodToRefresh {
                updateInfo()
            }
            print("")
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}


