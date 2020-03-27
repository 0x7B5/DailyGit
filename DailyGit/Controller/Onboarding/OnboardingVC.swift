//
//  OnboardingVC.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/11/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD


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
            var loadingNotification = JGProgressHUD(style: .dark)
            
            if !(Constants.darkMode) {
                loadingNotification = JGProgressHUD(style: .light)
            }
            
            if let username = usernameTF.text {
                GithubDataManager.shared.isGithubUser(username: username, completion: {
                    userExists in
                    if (!userExists) {
                        DispatchQueue.main.async { [weak self] in
                            loadingNotification.dismiss(afterDelay: 3.0)
                            let alert = UIAlertController(title: "Username not found", message: "Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self!.present(alert, animated: true, completion: {
                            })
                        }
                        
                    } else {
                        
                        
                        DispatchQueue.main.async { () -> Void in
                            loadingNotification.textLabel.text = "Pulling User Data"
                            loadingNotification.show(in: self.view)
                        }
                        
                        GithubDataManager.shared.setupGithubUser(username: username, completion: {
                            user in
                            loadingNotification.dismiss(afterDelay: 3.0)
                            UserInfoHelper.shared.resetDefaults()
                            let encoder = JSONEncoder()
                            if (try? encoder.encode(user)) != nil {
                                UserInfoHelper.shared.updateUserInDefaults(userToEncode: user!)
                                DispatchQueue.main.async { [weak self] in
                                    let vc =  MainTabBarController()
                                    vc.modalPresentationStyle = .fullScreen
                                    self!.present(vc, animated: true, completion: {
                                       loadingNotification.dismiss(afterDelay: 3.0)
                                    })
                                }
                            } else {
                                DispatchQueue.main.async { [weak self] in
                                    loadingNotification.dismiss(afterDelay: 3.0)
                                    let alert = UIAlertController(title: "Error Occured", message: "Please try again.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                    self!.present(alert, animated: true, completion: {
                                      //  self.usernameTF.becomeFirstResponder()
                                    })
                                }
                            }
                        })
                        
                    }
                })
            }
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: {
               // self.usernameTF.becomeFirstResponder()
            })
        }
        usernameTF.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTF.becomeFirstResponder()
        
        if #available(iOS 12.0, *) {
            switch UIScreen.main.traitCollection.userInterfaceStyle {
            case .light:
                Constants.darkMode = false
            case .dark:
                Constants.darkMode = true
            case .unspecified:
                Constants.darkMode = true
            @unknown default:
                Constants.darkMode = true
            }
        } else {
           Constants.darkMode = true
        }
        
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
