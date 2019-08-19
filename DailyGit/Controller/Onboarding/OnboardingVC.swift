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
    
    override func loadView() {
        self.view = onboardingView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(goNext))
        self.usernameTF.delegate = self
        print("We Out Here")
    }
    
    @objc func goNext() {
        view.endEditing(true)
        if let username = usernameTF.text {
            GithubDataManager.shared.setupGithubUser(username: username, completion: {
                user in
                //animate
                DispatchQueue.main.async { [weak self] in
                    if user == nil {
                        print("Not found")
                        let alert = UIAlertController(title: "Username not found", message: "Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self!.present(alert, animated: true)
                    } else {
                        print("JSON ")
                        let encoder = JSONEncoder()
                        if let encoded = try? encoder.encode(user) {
                            print("setting")
                            let defaults = UserDefaults.standard
                            defaults.set(encoded, forKey: "CurrentUser")
                            let vc =  MainTabBarController()
                            self!.present(vc, animated: true, completion: nil)
                        } else {
                            print("error")
                            let alert = UIAlertController(title: "Error Occured", message: "Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self!.present(alert, animated: true)
                        }
                    }
                }
                
                
            })
            
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
