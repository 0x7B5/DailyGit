//
//  ContributionInsightVC.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/9/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import UIKit

class ContributionInsightVC: UIViewController {
    lazy var mainView = CommitsView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
