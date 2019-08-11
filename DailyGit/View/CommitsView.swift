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
       
        for i in 0...7 {
         weekCommitGraph.append(createGraphNodeView())
        }
        
       
        
    }
    
    public func createConstraints() {
//        middleView.snp.makeConstraints {
//            $0.height.equalToSuperview().multipliedBy(0.3)
//            $0.width.equalToSuperview()
//            $0.top.equalToSuperview()
//
//        }
    }
    //SUBVIEWS
    //TOPVIEW: PROFILE VIEW
    let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileImage: UIImageView = {
        let view = UIImageView()
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
