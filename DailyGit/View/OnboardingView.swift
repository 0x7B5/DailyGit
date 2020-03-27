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
        addSubview(githubPhoto)
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
        
        #warning("BLURRY")
        githubPhoto.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.6373333333)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(bgView1.snp.centerY).multipliedBy(1.08)
        }
        
        #warning("GET KEYBOARD HEIGHT https://stackoverflow.com/questions/31774006/how-to-get-height-of-keyboard")
        // Get
        loginView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.885)
            $0.height.equalTo(loginView.snp.width).multipliedBy(0.77)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.85)
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
            $0.bottom.equalToSuperview().inset(24)
            $0.height.equalToSuperview().multipliedBy(0.18)
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
        
        label.font = UIFont.systemFont(ofSize: 30.0, weight: UIFont.Weight.regular)
        label.adjustsFontSizeToFitWidth = true
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
        textfield.font = UIFont.systemFont(ofSize: 30.0, weight: UIFont.Weight.thin)
        textfield.adjustsFontSizeToFitWidth = true
        //textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.textAlignment = .left
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.keyboardType = UIKeyboardType.default
        textfield.returnKeyType = UIReturnKeyType.done
        textfield.clearButtonMode = UITextField.ViewMode.never
        textfield.autocapitalizationType = .none
        textfield.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textfield.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return textfield
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
         
        button.backgroundColor = Constants.blueColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    //GitHub logo pic
    let githubPhoto: UIImageView = {
        let photo = UIImageView()
        photo.image = UIImage(named: "onboardGit")
        photo.contentMode = .scaleAspectFit
        return photo
    }()
    
    
    func createViews(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 40
        return view
    }
    
}
