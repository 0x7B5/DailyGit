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
        addSubview(enterUsernameLabel)
        addSubview(usernameTextfield)
        addSubview(dontKnowUsernameLabel)
        addSubview(githubPhoto)
    }
    
    public func createConstraints() {
        enterUsernameLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            //$0.height.equalToSuperview().multipliedBy(0.13)
            $0.centerY.equalToSuperview().multipliedBy(0.35)
        }
        usernameTextfield.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.65)
        }
        dontKnowUsernameLabel.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.0)
        }
        githubPhoto.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.5)
        }
    }
    
   
    //Enter Github Username
    let enterUsernameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 50.0)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Enter GitHub Username"
        label.textAlignment = .center
        label.textColor = Constants.titleColor
        return label
    }()
    
    //Textfield
    let usernameTextfield: UITextField = {
        let textfield = UITextField()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        let attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)])
        textfield.attributedPlaceholder = attributedPlaceholder
        //textfield.placeholder = "Username"
        textfield.font = UIFont.systemFont(ofSize: 42, weight: UIFont.Weight(rawValue: 1.0))
        textfield.adjustsFontSizeToFitWidth = true
        //textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.textAlignment = .center
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.keyboardType = UIKeyboardType.default
        textfield.returnKeyType = UIReturnKeyType.done
        textfield.clearButtonMode = UITextField.ViewMode.whileEditing
        textfield.autocapitalizationType = .none
        textfield.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textfield.textColor = Constants.subTitleColor
        return textfield
    }()
    
    
    func startLoading() {
        
        usernameTextfield.removeFromSuperview()
       
    }
    
    func stopLoading() {
       
        addSubview(usernameTextfield)
        usernameTextfield.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.65)
        }
    }
    
    
    //Don't know username
    let dontKnowUsernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25.0)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Don't know your username? Go to your GitHub profile and find it in the URL."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = Constants.titleColor
        return label
    }()
    
    
    
    //GitHub profile pic
    let githubPhoto: UIImageView = {
        let photo = UIImageView()
        photo.image = UIImage(named: "samplePage")
        photo.contentMode = .scaleAspectFit
        return photo
    }()
    
}
