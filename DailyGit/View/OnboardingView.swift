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
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
            $0.centerY.equalToSuperview().multipliedBy(0.55)
        }
    }
    
    //Next Button
//    let nextButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Next",for: .normal)
//        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
//
//        return button
//    }()
    
    //Enter Github Username
    let enterUsernameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 50.0)
        
        label.adjustsFontSizeToFitWidth = true
        label.text = "Enter GitHub Username"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    //Textfield
    let usernameTextfield: UITextField = {
        let textfield = UITextField()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        let attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.font = UIFont.systemFont(ofSize: 45, weight: UIFont.Weight(rawValue: 1.0))
        textfield.adjustsFontSizeToFitWidth = true
        //textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.textAlignment = .center
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.keyboardType = UIKeyboardType.default
        textfield.returnKeyType = UIReturnKeyType.done
        textfield.clearButtonMode = UITextField.ViewMode.whileEditing
        textfield.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textfield
    }()
    
    //Don't know username
    let dontKnowUsernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50.0)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Don't know your username? Go to your GitHub profile and find it in the URL."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.6)
        return label
    }()
    
    //GitHub profile pic
    let githubPhoto: UIImageView = {
        let photo = UIImageView()
        return photo
    }()
    
}
