//
//  MainView.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/28/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit
import SnapKit

public class CommitsView: UIView {
    var topLayout: CGFloat
    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }
    
    init(topLayout: CGFloat) {
        self.topLayout = topLayout
        super.init(frame: CGRect.zero)
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
        addSubview(topView)
        topView.addSubview(profileImage)
        
        for i in 0...7 {
         weekCommitGraph.append(createGraphNodeView())
        }
        
        
       
        
    }
    
    public func createConstraints() {
        topView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.15)
            $0.top.equalToSuperview().inset(topLayout)
        }
        profileImage.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.83)
            $0.height.equalTo(profileImage.snp.width)
            $0.left.equalToSuperview().multipliedBy(0.9)
            $0.centerY.equalToSuperview()
            
            
        }
    }
    //SUBVIEWS
    //TOPVIEW: PROFILE VIEW
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    let profileImage: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = view.frame.height/2
        
        //Provide default image
        view.image = #imageLiteral(resourceName: "blankProfilePic")
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
            return label
    }()
    //TODAY VIEW
    let todayLabel: UILabel = {
        let label = UILabel()
            return label
    }()
    
    let dailyCommitsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    //THIS WEEK VIEW
    let weekLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //CURRENT STREAK VIEW
    let currentStreakLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let currentStreakCommitsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //LONGEST STREAK VIEW
    let longestStreakLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var weekCommitGraph = [UIView]()
    
    
    
    internal func createGraphNodeView() -> UIView {
        let view = UIView()
        return view
    }
    
    let longestStreakCommitsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    
}
