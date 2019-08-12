//
//  OnboardingVC.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/11/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit

public class OnboardingVC: UIViewController {
    
    let onboardingView = OnboardingView()
    public override func loadView() {
        self.view = onboardingView
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(goNext))
        print("We Out Here")
    }
    
    @objc func goNext() {
        
    }
    
}
