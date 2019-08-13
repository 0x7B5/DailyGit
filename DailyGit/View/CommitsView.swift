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
        //addSubview(topView)
        addSubview(profileImage)
        addSubview(nameLabel)
        
        for i in 0...7 {
         weekCommitGraph.append(createGraphNodeView())
        }
        
    }
    
    public func createConstraints() {
//        topView.snp.makeConstraints {
//            $0.width.equalToSuperview()
//            $0.height.equalToSuperview().multipliedBy(0.15)
//            $0.top.equalToSuperview().inset(topLayout)
//        }
        profileImage.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.24)
            $0.height.equalTo(profileImage.snp.width)
            $0.centerX.equalToSuperview().multipliedBy(0.28)
            #warning("This doesn't quite look right on larger devices")
            //$0.top.equalToSuperview().inset(topLayout+30)
            $0.centerY.equalToSuperview().multipliedBy(0.35)
        }
        nameLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.left.equalTo(profileImage.snp.right).offset(10)
            $0.height.equalToSuperview().multipliedBy(0.045)
            $0.centerY.equalToSuperview().multipliedBy(0.26)
            
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
        //view.layer.cornerRadius = view.frame.height/2
        view.contentMode = .scaleAspectFit
        
        //Provide default image
        view.image = #imageLiteral(resourceName: "sampleIcon")
        return view
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40.0, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Vlad Munteanu"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
