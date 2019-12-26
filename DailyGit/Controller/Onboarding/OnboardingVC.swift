//
//  OnboardingVC.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/11/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit


class OnboardingVC: UIViewController, UITextFieldDelegate {
    
    let onboardingView = OnboardingView()
    unowned var usernameTF: UITextField { return onboardingView.usernameTextfield}
    
    unowned var activityIndicator: UIActivityIndicatorView { return onboardingView.activityIndicator}
    
    
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
        onboardingView.startLoading()
        if Reachability.shared.isConnectedToNetwork(){
            if let username = usernameTF.text {
                GithubDataManager.shared.isGithubUser(username: username, completion: {
                    userExists in
                    DispatchQueue.main.async { [weak self] in
                        self!.onboardingView.stopLoading()
                        
                        if (!userExists) {
                            let alert = UIAlertController(title: "Username not found", message: "Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self!.present(alert, animated: true)
                        } else {
                            GithubDataManager.shared.setupGithubUser(username: username, completion: {
                                user in
                                ReadUserInfoHelper.shared.resetDefaults()
                                let encoder = JSONEncoder()
                                if let encoded = try? encoder.encode(user) {
                                    let defaults = UserDefaults.standard
                                    defaults.set(encoded, forKey: "CurrentUser")
                                    defaults.synchronize()
                                    let vc =  MainTabBarController()
                                    vc.modalPresentationStyle = .fullScreen
                                    self!.present(vc, animated: true, completion: nil)
                                } else {
                                    let alert = UIAlertController(title: "Error Occured", message: "Please try again.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                    self!.present(alert, animated: true)
                                }
                            })
                        }
                    }
                })
            }
        } else {
            onboardingView.stopLoading()
            let alert = UIAlertController(title: "No Internet Connection", message: "Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        //onboardingView.stopLoading()
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
