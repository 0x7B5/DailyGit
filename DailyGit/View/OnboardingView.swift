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
        addSubview(usernameTextfield)
        addSubview(githubPhoto)
        addSubview(bgView1)
        addSubview(bgView2)
        addSubview(bgView3)
    }
    
    public func createConstraints() {
        usernameTextfield.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.65)
        }
        
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
    }
    
    lazy var bgView1 = createViews()
    lazy var bgView2 = createViews()
    lazy var bgView3 = createViews()
   
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
    
    //GitHub logo pic
    let githubPhoto: UIImageView = {
        let photo = UIImageView()
        photo.image = UIImage(named: "gitLogo")
        photo.contentMode = .scaleAspectFit
        return photo
    }()
    
    
    func createViews() -> UIView {
        let view = UIView()
        view.backgroundColor = Constants.blueColor
        view.layer.cornerRadius = 40
        return view
    }
    
}
