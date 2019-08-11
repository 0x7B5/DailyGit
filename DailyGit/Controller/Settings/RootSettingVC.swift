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
    
    func setupView() {
//        let titleLabel = UILabel()
//        titleLabel.text = "QuickTableViewController"
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
//        title = " "
//        navigationItem.titleView = titleLabel
        
        tableContents = [
            Section(title: "Default", rows: [
                NavigationRow(text: "Use default cell types", detailText: .none, action: { [weak self] _ in
                   // self?.navigationController?.pushViewController(ExampleViewController(), animated: true)
                })
            ]),
            
            Section(title: "Customization", rows: [
                NavigationRow(text: "Use custom cell types", detailText: .none, action: { [weak self] _ in
                    //self?.navigationController?.pushViewController(CustomizationViewController(), animated: true)
                })
            ]),
            
            Section(title: "UIAppearance", rows: [
                NavigationRow(text: "UILabel customization", detailText: .none, action: { [weak self] _ in
                    //self?.navigationController?.pushViewController(AppearanceViewController(), animated: true)
                })
            ]),
            
            Section(title: "In-App Purchases", rows: [
                TapActionRow(text: "No Ads", action: showAlert()),
            ], footer: "DailyGit will always be free to use. If you find it useful, please consider supporting the app by purchasing the No Ads IAP."),
            
        ]
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
    
    func setupNavController() {
        self.title = "Settings"
        self.navigationController?.navigationBar.barTintColor = Constants.navBarColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.gitGreenColor]
    }
}
