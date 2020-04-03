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
import SnapKit

class OnboardingVC: UIViewController, UITextFieldDelegate {
    
    var keyboardShownIntially = false
    var currentKeyboardHeight: CGFloat = 291.0
    let onboardingView = OnboardingView()
    unowned var usernameTF: UITextField { return onboardingView.usernameTextfield}
    
    unowned var nextButton: UIButton { return onboardingView.nextButton}
    unowned var loginView: UIView { return onboardingView.loginView}
    unowned var githubPhoto: UIImageView { return onboardingView.githubPhoto}
    
    override func loadView() {
        self.view = onboardingView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nextButton.addTarget(self, action: #selector(goNext), for: UIControl.Event.touchUpInside)
        self.usernameTF.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        if !Reachability.shared.isConnectedToNetwork(){
            let alert = UIAlertController(title: "No Internet Connection", message: "Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @objc func goNext() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        #warning("There's something not working here because of networking or something I think")
        if Reachability.shared.isConnectedToNetwork(){
            let loadingNotification = JGProgressHUD(style: .light)
            
            if var username = usernameTF.text  {
                username = username.replacingOccurrences(of: " ", with: "")
                GithubDataManager.shared.isGithubUser(username: username, completion: {
                    userExists in
                    if (!userExists) {
                        DispatchQueue.main.async { [weak self] in
                            let alert = UIAlertController(title: "Username not found", message: "Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                                (alert: UIAlertAction!) in
                                self!.usernameTF.becomeFirstResponder()
                            }))
                            UIApplication.shared.endIgnoringInteractionEvents()
                            self!.present(alert, animated: true)
                        }
                        
                    } else {
                        DispatchQueue.main.async { () -> Void in
                            loadingNotification.textLabel.text = "Pulling User Data"
                            
                            for view in self.loginView.subviews as [UIView] {
                                view.isHidden = true
                            }
                            self.loginView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                            loadingNotification.show(in: self.loginView)
                        }
                        
                        GithubDataManager.shared.setupGithubUser(username: username, completion: {
                            user in
                            UserInfoHelper.shared.resetDefaults()
                            if user != nil {
                                UserInfoHelper.shared.updateUserInDefaults(userToEncode: user!)
                                DispatchQueue.main.async { [weak self] in
                                    self!.presentLoadingAfter(loadingNotification, sucess: true, subtitleText: nil)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        let vc =  UINavigationController(rootViewController: MainVC())
                                        vc.modalPresentationStyle = .fullScreen
                                        self!.present(vc, animated: true)
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                    }
                                }
                            } else {
                                DispatchQueue.main.async { [weak self] in
                                    self!.presentLoadingAfter(loadingNotification, sucess: false, subtitleText: "Please try again")
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        for view in self!.loginView.subviews as [UIView] {
                                            view.isHidden = false
                                            
                                            if ((view as? UITextField) != nil) {
                                                view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                                            }
                                        }
                                        self!.loginView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                        
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                        self!.usernameTF.becomeFirstResponder()
                                    }
                                }
                            }
                        })
                        
                    }
                })
            }
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                (alert: UIAlertAction!) in
                self.usernameTF.becomeFirstResponder()
            }))
            UIApplication.shared.endIgnoringInteractionEvents()
            self.present(alert, animated: true)
            
        }
        usernameTF.text = ""
    }
    
    func presentLoadingAfter(_ hud: JGProgressHUD, sucess: Bool, subtitleText: String?) {
        if sucess {
            UIView.animate(withDuration: 0.1, animations: {
                hud.textLabel.text = "Success"
                hud.detailTextLabel.text = nil
                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            })
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                hud.textLabel.text = "Error"
                hud.detailTextLabel.text = subtitleText!
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
            })
        }
        
        
        hud.dismiss(afterDelay: 2.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTF.becomeFirstResponder()
    }
    
    /*  UIKeyboardWillShowNotification. */
    @objc internal func keyboardWillShow(_ notification : Notification?) -> Void {
        
        var _kbSize:CGSize!
        
        if let info = notification?.userInfo {
            
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            
            //  Getting UIKeyboardSize.
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                
                let screenSize = UIScreen.main.bounds
                
                //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
                let intersectRect = kbFrame.intersection(screenSize)
                
                if intersectRect.isNull {
                    _kbSize = CGSize(width: screenSize.size.width, height: 0)
                } else {
                    _kbSize = intersectRect.size
                }
                
                if (keyboardShownIntially) {
                    if currentKeyboardHeight != _kbSize.height {
                        updateViewHeightConstraints(height: currentKeyboardHeight-_kbSize.height)
                        currentKeyboardHeight = _kbSize.height
                    }
                } else {
                    keyboardShownIntially = true
                }
                
            }
        }
    }
    
    func updateViewHeightConstraints(height: CGFloat) {
        loginView.snp.updateConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.85).offset((height/8))
        }
        
        self.view.layoutIfNeeded()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        goNext()
        return false
    }
}
