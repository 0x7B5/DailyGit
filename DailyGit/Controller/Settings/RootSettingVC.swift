//
//  SettingsVC.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/28/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit
import QuickTableViewController

class RootSettingVC: QuickTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()
        setupView()
        
    }
    
    #warning("low energy mode!!!!!!!!")
    func setupView() {
        //        let titleLabel = UILabel()
        //        titleLabel.text = "QuickTableViewController"
        //        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        //        title = " "
        //        navigationItem.titleView = titleLabel
        #warning("Add username to subtitle")
        tableContents = [
            Section(title: "Username", rows: [
                NavigationRow(text: "Change Account", detailText: .subtitle("Current Username: \(UserInfoHelper.shared.readInfo(info: .username) as? String ?? "")"), action: { [weak self] _ in
                    let nextViewController = OnboardingVC()
//                    navController.modalPresentationStyle = .fullScreen
//                    self!.present(navController, animated: true, completion: nil)
                    
//                    /let nextViewController = RootSettingVC()
                    self?.navigationController?.pushViewController(nextViewController, animated: true)
                })
            ]),
            
            
            Section(title: "Notifications", rows: [
                SwitchRow(text: "Profane Notifications", switchValue: Constants.profaneNotications, action: { [weak self] _ in
                    self?.changeNotificationsToProfane()
                }),
                SwitchRow(text: "Auto Refresh", switchValue: Constants.timerStatus, action: { [weak self] _ in
                    #warning("Take out in production")
                    if Constants.timerStatus {
                        AutoUpdater.shared.stopTimer()
                    } else {
                        AutoUpdater.shared.startTimer()
                    }
                    
                }),
            ]),
            
            
                        Section(title: "RESET DEFAULTS", rows: [
            
                            TapActionRow(text: "DEBUG DEBUG", action: { [weak self] _ in
                                self?.resetDefaults()
                            })
                        ], footer: ""),
            
        ]
    }
    
    #warning("Check if this automatically updates notifaction")
    func changeNotificationsToProfane() {
        Constants.profaneNotications.toggle()
    }
    
    #warning("Debug purposes")
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        fatalError()
    }
    
    func showAlert() -> (Row) -> Void {
        return { [weak self] _ in
            let alert = UIAlertController(title: "Action Triggered", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    //    private func showDetail() -> (Row) -> Void {
    //      return { [weak self] in
    //        let detail = $0.text + ($0.detailText?.text ?? "")
    //        let controller = UIViewController()
    //        controller.view.backgroundColor = .white
    //        controller.title = detail
    //        self?.navigationController?.pushViewController(controller, animated: true)
    //
    //      }
    //    }
    
    
    func setupNavController() {
        self.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.gitGreenColor]
    }
}
