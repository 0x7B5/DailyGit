//
//  OnboardingVC.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/11/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD


class OnboardingVC: UIViewController, UITextFieldDelegate {
    
    let onboardingView = OnboardingView()
    unowned var usernameTF: UITextField { return onboardingView.usernameTextfield}
    
    override func loadView() {
        self.view = onboardingView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(goNext))
        self.usernameTF.delegate = self
        if !Reachability.shared.isConnectedToNetwork(){
            let alert = UIAlertController(title: "No Internet Connection", message: "Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @objc func goNext() {
        view.endEditing(true)
        #warning("There's something not working here because of networking or something I think")
        if Reachability.shared.isConnectedToNetwork(){
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            if let username = usernameTF.text {
                GithubDataManager.shared.isGithubUser(username: username, completion: {
                    userExists in
                    DispatchQueue.main.async { () -> Void in
                        loadingNotification.mode = MBProgressHUDMode.indeterminate
                        loadingNotification.label.text = "Checking if user exists"
                    }
                    if (!userExists) {
                        DispatchQueue.main.async { [weak self] in
                            loadingNotification.hide(animated: true)
                            
                            let alert = UIAlertController(title: "Username not found", message: "Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self!.present(alert, animated: true)
                        }
                        
                    } else {
                        
                        DispatchQueue.main.async { () -> Void in
                            loadingNotification.hide(animated: true)
                        }
                        GithubDataManager.shared.setupGithubUser(username: username, completion: {
                            user in
                            
//                            loadingNotification.mode = MBProgressHUDMode.indeterminate
//                            loadingNotification.label.text = "Pulling user's GitHub data"
                            
                            UserInfoHelper.shared.resetDefaults()
                            let encoder = JSONEncoder()
                            if let encoded = try? encoder.encode(user) {
                                UserInfoHelper.shared.updateUserInDefaults(userToEncode: user!)
                                DispatchQueue.main.async { [weak self] in
                                    let vc =  MainTabBarController()
                                    vc.modalPresentationStyle = .fullScreen
                                    self!.present(vc, animated: true, completion: {
                                        loadingNotification.hide(animated: true)
                                    })
                                }
                            } else {
                                DispatchQueue.main.async { [weak self] in
                                    loadingNotification.hide(animated: true)
                                    let alert = UIAlertController(title: "Error Occured", message: "Please try again.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                    self!.present(alert, animated: true)
                                }
                            }
                        })
                        
                    }
                })
            }
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        usernameTF.text = ""
    }
    
    
    
    override  func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        goNext()
        return false
    }
}
