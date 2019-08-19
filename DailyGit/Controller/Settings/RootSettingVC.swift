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
        #warning("Add username to subtitle")
        tableContents = [
            Section(title: "Username", rows: [
                
        
        NavigationRow(text: "Change Account", detailText: .subtitle("Current Username:"), action: { [weak self] _ in
                    let navController = UINavigationController(rootViewController: OnboardingVC())
                    self!.present(navController, animated: true, completion: nil)
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
            
            Section(title: "RESET DEFAULTS", rows: [
              
                TapActionRow(text: "DEBUG DEBUG", action: { [weak self] _ in
                    self?.resetDefaults()
                })
            ], footer: ""),
            
        ]
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
        //self.navigationController?.navigationBar.barTintColor = Constants.navBarColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.gitGreenColor]
    }
}
