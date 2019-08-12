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
       
       
    }
    
    public func createConstraints() {
        
    }
    
    //Next Button
    let nextButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    //Enter Github Username
    let enterUsernameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //Textfield
    let usernameTextfield: UITextField = {
        let textfield = UITextField()
        return textfield
    }()
    
    //Don't know username
    let dontKnowUsernameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //GitHub profile pic
    let githubPhoto: UIImageView = {
        let photo = UIImageView()
        return photo
    }()
    
}
