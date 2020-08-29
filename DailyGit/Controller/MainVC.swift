//
//  MainVC.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/28/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit
import WatchConnectivity
import UserNotifications

class MainVC: UIViewController, UIGestureRecognizerDelegate {
    
    lazy var mainView = CommitsView()
    unowned var topView: UIView { return mainView.topView}
    unowned var todayView: TodaySubView { return mainView.todayView}
    unowned var scrollView: UIScrollView {return mainView.scrollView}
    unowned var monthlyAvgView: StatisticsAverageView {return mainView.monthlyAvgView}
    unowned var weeklyAvgView: StatisticsAverageView {return mainView.weeklyAvgView}
    
    unowned var monthlyPercentView: StatisticsPercentageView {return mainView.monthlyPercentageView}
    unowned var weeklyPercentView: StatisticsPercentageView {return mainView.weeklyPercentageView}
    
    unowned var thisWeekView: WeeklySubView {return mainView.weekView}
    unowned var lastWeekView: WeeklySubView {return mainView.lastWeekView}
    
    override func viewDidLayoutSubviews() {
        mainView.topView.profileImage.makeRounded(frameSize: self.mainView.topView.frame.width)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        updateInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//         
        
        setupNavController()
        NotificationCenter.default.addObserver(self, selector: #selector(autoRefresher), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        addTouchRecognizer()
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
    }
    
    func setupNotifications() {
        
        let notificationStatus = UserInfoHelper.shared.readNotificationData(info: .full) as? NotificationStatus
        
        if let status = notificationStatus?.notificationsEnabled {
            if (!status)  {
                if (notificationStatus?.date == nil) || (UserInfoHelper.shared.canIAskAgain(date: (notificationStatus?.date!)!, times: (notificationStatus?.times) ?? 0)) {
                    promptForNotifications()
                }
            }
            
            // bool is set to nil
        } else if notificationStatus?.notificationsEnabled == nil {
            promptForNotifications()
        }
        
    }
    
    func promptForNotifications() {
        let alertController = UIAlertController(title: "Do you want to recieve alerts reminding you to code?", message: "Great! We can notify you.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            
            if #available(iOS 10.0, *) {
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
            }
            
            UIApplication.shared.registerForRemoteNotifications()
            let newStatus = NotificationStatus(notificationsEnabled: true, date: nil, times: nil)
            UserInfoHelper.shared.setNotificationStatus(status: newStatus)
            
            let defaults = UserDefaults.standard
            defaults.set(1, forKey: "NotificationTime")
            defaults.synchronize()
            
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            let times = UserInfoHelper.shared.readNotificationData(info: .times) as? Int ?? 0  + 1
            let newStatus = NotificationStatus(notificationsEnabled: false, date: Date(), times: times)
            UserInfoHelper.shared.setNotificationStatus(status: newStatus)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addTouchRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(monthlySwitch))
        gestureRecognizer.delegate = self
        monthlyAvgView.addGestureRecognizer(gestureRecognizer)
        
        let gestureRecognizerTwo = UITapGestureRecognizer(target: self, action: #selector(weeklySwitch))
        gestureRecognizerTwo.delegate = self
        weeklyAvgView.addGestureRecognizer(gestureRecognizerTwo)
        
        let gestureRecognizerThree = UITapGestureRecognizer(target: self, action: #selector(monthlyPercentSwitch))
        gestureRecognizerThree.delegate = self
        monthlyPercentView.addGestureRecognizer(gestureRecognizerThree)
        
        let gestureRecognizerFour = UITapGestureRecognizer(target: self, action: #selector(weeklyPercentSwitch))
        gestureRecognizerFour.delegate = self
        weeklyPercentView.addGestureRecognizer(gestureRecognizerFour)
        
        let gestureRecognizerFive = UITapGestureRecognizer(target: self, action: #selector(weekSwitch))
        gestureRecognizerFive.delegate = self
        thisWeekView.addGestureRecognizer(gestureRecognizerFive)
        
        let gestureRecognizerSix = UITapGestureRecognizer(target: self, action: #selector(lastWeekSwitch))
        gestureRecognizerSix.delegate = self
        lastWeekView.addGestureRecognizer(gestureRecognizerSix)
        
        
    }
    
    @objc func lastWeekSwitch() {
        if lastWeekView.viewType == .week {
            lastWeekView.viewType = .month
        } else {
            lastWeekView.viewType = .week
        }
        mainView.switchLastWeek()
    }
    
    @objc func weekSwitch() {
        if thisWeekView.viewType == .week {
            thisWeekView.viewType = .month
        } else {
            thisWeekView.viewType = .week
        }
        mainView.switchThisWeek()
    }
    
    @objc func monthlyPercentSwitch() {
        if monthlyPercentView.viewType == .percent {
            monthlyPercentView.viewType = .number
        } else {
            monthlyPercentView.viewType = .percent
        }
        
        monthlyPercentView.changeNum()
    }
    
    @objc func weeklyPercentSwitch() {
        if weeklyPercentView.viewType == .percent {
            weeklyPercentView.viewType = .number
        } else {
            weeklyPercentView.viewType = .percent
        }
        
        weeklyPercentView.changeNum()
    }
    
    @objc func monthlySwitch() {
        if monthlyAvgView.viewType == .percent {
            monthlyAvgView.viewType = .average
        } else {
            monthlyAvgView.viewType = .percent
        }
        
        monthlyAvgView.changeNum()
    }
    
    @objc func weeklySwitch() {
        if weeklyAvgView.viewType == .percent {
            weeklyAvgView.viewType = .average
        } else {
            weeklyAvgView.viewType = .percent
        }
        
        weeklyAvgView.changeNum()
    }
    
    func updateInfo() {
        let start = NSDate()
        UserInfoHelper.shared.refreshEverything(completion: {
            print("Finished refreshing.")
            DispatchQueue.main.async { () -> Void in
                self.updateUI()
                let elapsed = start.timeIntervalSinceNow
                print("Update Info took \(abs(elapsed)) seconds")
            }
        })
        
        
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
            // Yesterday
        } else if place.x > tempWidth/3 && place.x < ((tempWidth/3) * 2) {
            // Today
        } else if place.x > ((tempWidth/3) * 2) {
            mainView.changeStreak()
        }
    }
    
    
    func updateUI() {
        let start = NSDate()
        var name = ""
        
        if let tempuser = UserInfoHelper.shared.readInfo(info: .user) as? User {
            if Constants.fullName == "full" {
                name = tempuser.name
                   } else {
                       name = tempuser.username
                   }
            self.mainView.topView.nameLabel.text = name
            self.mainView.topView.bioLabel.text = tempuser.bio
            self.mainView.topView.checkAllignmentForTitle(user: tempuser)
            self.mainView.todayView.setNumberLabels(user: tempuser)
            self.mainView.setLastUpdatedLabel(user: tempuser)
            
            // Try updating this
            self.mainView.lastWeekView.setupColorsForWeek(user: tempuser)
            self.mainView.updateStatistics()
            
            
        }
        
        sendDataToWatch()
        let elapsed = start.timeIntervalSinceNow
        print("It took \(abs(elapsed)) seconds wtf")
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
            
            updateInfo()
            
            print("")
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}

extension MainVC: WCSessionDelegate {
    func sendDataToWatch() {
        // send a message to the watch if it's reachable
        if (WCSession.default.isReachable) {
            
            if let username = UserInfoHelper.shared.readInfo(info: .username) as? String, let creationYear = UserInfoHelper.shared.readInfo(info: .yearCreated) as? Int{
                let message = ["username": username, "creationYear": String(creationYear)]
                WCSession.default.sendMessage(message, replyHandler: nil)
            }
        }
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
}

