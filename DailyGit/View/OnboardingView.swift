//
//  OnboardingView.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/12/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit
import SnapKit

public class OnboardingView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.zero
        backgroundColor = Constants.mainBGColor
        initializeUI()
        createConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeUI() {
        //UIViews
        
        
        addSubview(bgView1)
        addSubview(bgView2)
        addSubview(bgView3)
        addSubview(githubLogoView)
        githubLogoView.addSubview(githubPhoto)
        addSubview(loginView)
        loginView.addSubview(usernameTextfield)
        loginView.addSubview(enterUsernameLabel)
        loginView.addSubview(nextButton)
    }
    
    public func createConstraints() {
        
        bgView1.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.47)
            $0.centerY.equalToSuperview().multipliedBy(0.3)
        }
        
        bgView2.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.47)
            $0.centerY.equalToSuperview().multipliedBy(1.5)
            $0.right.equalToSuperview().multipliedBy(1.7)
        }
        
        
        //0.8241469816
        bgView3.snp.makeConstraints {
            $0.width.equalTo(bgView2.snp.width).multipliedBy(0.73333)
            $0.height.equalTo(bgView2.snp.height).multipliedBy(0.8241469816)
            $0.centerY.equalToSuperview().multipliedBy(1.45)
            $0.centerX.equalToSuperview().multipliedBy(0.05)
        }
        
        bgView2.transform = CGAffineTransform(rotationAngle: 0.331613)
        bgView3.transform = CGAffineTransform(rotationAngle: 0.331613)
        
        
        #warning("Fix ME")
        //Put this in its own view for sizing purposes
        #warning("BLURRY")
        
        
        githubLogoView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(bgView1.snp.height).multipliedBy(0.5)
        }
        
        if UIDevice.current.hasNotch {
            githubPhoto.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.15)
                $0.height.equalTo(githubPhoto.snp.width)
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().multipliedBy(1.08)
            }
        } else {
            if (Constants.isIpad) {
                githubPhoto.snp.makeConstraints {
                    $0.width.equalToSuperview().multipliedBy(0.08)
                    $0.height.equalTo(githubPhoto.snp.width)
                    $0.centerX.equalToSuperview()
                    $0.centerY.equalToSuperview().multipliedBy(0.8)
                }
                githubLogoView.snp.updateConstraints{
                    $0.top.equalToSuperview().offset(30)
                }
            } else {
                githubPhoto.snp.makeConstraints {
                    $0.width.equalToSuperview().multipliedBy(0.15)
                    $0.height.equalTo(githubPhoto.snp.width)
                    $0.centerX.equalToSuperview()
                    $0.centerY.equalToSuperview().multipliedBy(0.8)
                }
            }
        }
        
        
        setupGitLogos()
        
        
        if (Constants.isIpad) {
            loginView.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.60)
                $0.height.equalTo(loginView.snp.width).multipliedBy(0.54)
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().multipliedBy(0.85)
            }
        } else {
            loginView.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.885)
                $0.height.equalTo(loginView.snp.width).multipliedBy(0.65)
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().multipliedBy(0.85)
            }
        }
        
        loginView.layer.shadowColor = UIColor.black.cgColor
        loginView.layer.shadowOpacity = 0.2
        loginView.layer.shadowOffset = .zero
        loginView.layer.shadowRadius = 10
        
        usernameTextfield.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.88)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.0)
        }
        usernameTextfield.setBottomBorder()
        
        enterUsernameLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(15)
            $0.height.equalToSuperview().multipliedBy(0.22)
        }
        
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowOpacity = 0.2
        nextButton.layer.shadowOffset = .zero
        nextButton.layer.shadowRadius = 10
        
    }
    
    lazy var bgView1 = createViews(color: Constants.blueColor)
    lazy var bgView2 = createViews(color: Constants.blueColor)
    lazy var bgView3 = createViews(color: Constants.blueColor)
    let loginView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.mainBGColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    //Enter Github Username
    let enterUsernameLabel: UILabel = {
        let label = UILabel()
        
        label.font =  UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.text = "GitHub Username"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    //Textfield
    let usernameTextfield: UITextField = {
        let textfield = UITextField()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        let attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)])
        textfield.attributedPlaceholder = attributedPlaceholder
        //textfield.placeholder = "Username"
        textfield.font = UIFont.preferredFont(forTextStyle: .title2)
        textfield.adjustsFontForContentSizeCategory = true

        
        textfield.textAlignment = .left
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.keyboardType = UIKeyboardType.default
        textfield.returnKeyType = UIReturnKeyType.done
        textfield.clearButtonMode = UITextField.ViewMode.whileEditing
        textfield.autocapitalizationType = .none
        textfield.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textfield.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return textfield
    }()
    
    let nextButton: myButton = {
        let button = myButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.backgroundColor = Constants.blueColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    //GitHub logo pic
    
    let githubLogoView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.blueColor
        return view
    }()
    
    
    let githubPhoto: UIImageView = {
        let photo = UIImageView()
        photo.image = UIImage(named: "gitLogoSmall")
        photo.contentMode = .scaleAspectFit
        return photo
    }()
    
    func setupGitLogos() {
        var views = [UIView]()
        let colors = [#colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1),#colorLiteral(red: 0.7622682452, green: 0.8838019967, blue: 0.5061864853, alpha: 1),#colorLiteral(red: 0.4688351154, green: 0.7742896676, blue: 0.3937434554, alpha: 1),#colorLiteral(red: 0.1892609, green: 0.5697621107, blue: 0.1936196685, alpha: 1),#colorLiteral(red: 0.1181769744, green: 0.3007073998, blue: 0.1162960008, alpha: 1)]
        var currentCenterXMulitplier = 0.4
        
        if (Constants.isIpad) {
            currentCenterXMulitplier = 0.7
        }
        
        for i in 0...4 {
            let view = UIView()
            view.backgroundColor = colors[i]
            views.append(view)
            githubLogoView.addSubview(views[i])
            
            views[i].snp.makeConstraints {
                if (Constants.isIpad) {
                    $0.top.equalTo(githubPhoto.snp.bottom).offset(10)
                    $0.width.equalToSuperview().multipliedBy(0.05)
                    $0.height.equalTo(views[i].snp.width)
                    $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
                    currentCenterXMulitplier += 0.15
                } else {
                    $0.top.equalTo(githubPhoto.snp.bottom).offset(10)
                    $0.width.equalToSuperview().multipliedBy(0.1)
                    $0.height.equalTo(views[i].snp.width)
                    $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
                    currentCenterXMulitplier += 0.30
                }
                
                
            }
            
            views[i].layer.shadowColor = UIColor.black.cgColor
            views[i].layer.shadowOpacity = 0.2
            views[i].layer.shadowOffset = .zero
            views[i].layer.shadowRadius = 10
        }
        
    }
    
    func createViews(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 40
        return view
    }
    
}
