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
    
    #warning("Take out filler info.")
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
        addSubview(bioLabel)
        
        //Today
        addSubview(todayLabel)
        addSubview(dailyCommitsLabel)
        
        //This Week
        addSubview(weekLabel)
        setupWeekGrass()
        
        
        //Current Streak
        
        //Longest Streak
        
    }
    
    public func createConstraints() {
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
        
        bioLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.left.equalTo(profileImage.snp.right).offset(10)
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        todayLabel.snp.makeConstraints {
            $0.left.equalTo(profileImage.snp.left)
            $0.centerY.equalToSuperview().multipliedBy(0.56)
        }
        dailyCommitsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.75)
        }
        weekLabel.snp.makeConstraints {
            $0.left.equalTo(profileImage.snp.left)
            $0.centerY.equalToSuperview().multipliedBy(0.94)
        }
        
        //Week Commits View
        var currentCenterXMulitplier = 0.15
        for i in 0..<7 {
            weekCommitGraph[i].snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.11)
                $0.height.equalTo(weekCommitGraph[0].snp.width)
//                if i == 0 {
//                    $0.left.equalTo(profileImage.snp.left)
//                } else {
//                    $0.left.equalTo(weekCommitGraph[i-1].snp.right).offset(10)
//                }
                
                
                $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
                $0.centerY.equalToSuperview().multipliedBy(1.08)
                currentCenterXMulitplier += 0.2835
            }
           
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
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.adjustsFontSizeToFitWidth = true
        label.text = "An ounce of prevention is worth a pound of cure."
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.6)
        return label
    }()
    //TODAY VIEW
    lazy var todayLabel: UILabel = createTitleText(text: "Today")
    
    let dailyCommitsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 55.0, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "9"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    //THIS WEEK VIEW
    lazy var weekLabel: UILabel = createTitleText(text: "This Week")
    
    //CURRENT STREAK VIEW
    lazy var currentStreakLabel: UILabel = createTitleText(text: "Current Streak")
    
    var weekCommitGraph = [UIView]()
    
    public func setupWeekGrass() {
        for i in 0..<7 {
            weekCommitGraph.append(createGraphNodeView())
            addSubview(weekCommitGraph[i])
        }
    }
    
    public func setupWeekGrassLocation() {
        
    }
    
    internal func createGraphNodeView() -> UIView {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return view
    }
    
    let currentStreakCommitsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //LONGEST STREAK VIEW
    let longestStreakLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    internal func createTitleText(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25.0, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "\(text)"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.6)
        return label
    }
    
    let longestStreakCommitsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    
}
