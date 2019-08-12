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
    }
    
    override  func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
