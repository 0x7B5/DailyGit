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
        addSubview(currentStreakLabel)
        addSubview(currentStreakCommitsLabel)
        //Longest Streak
        addSubview(longestStreakLabel)
        addSubview(longestStreakCommitsLabel)
    }
    
    func checkAllignmentForTitle() {
        if ReadUserInfoHelper.shared.readInfo(info: .bio) as? String == "" {
            nameLabel.textAlignment = .center
            nameLabel.snp.makeConstraints{
                $0.width.equalToSuperview().multipliedBy(0.4)
                $0.centerX.equalToSuperview()
                $0.height.equalToSuperview().multipliedBy(0.045)
                $0.centerY.equalToSuperview().multipliedBy(0.34)
            }
        }
    }
    
    func setupColorsForWeek(contributions: ContributionList) {
        
        for (index, element) in contributions.contributions.enumerated() {
            let myIndex = element.color.index(element.color.startIndex, offsetBy: 1)
            let mySubstring = element.color.suffix(from: myIndex)
            
            let myColor = UIColor(rgb: (Int(mySubstring, radix: 16) ?? 0))
            
            weekCommitGraph[index].backgroundColor = myColor
            if element.date == DateHelper.shared.getFormattedDate() {
                weekCommitGraph[index].layer.borderWidth = 0.5
                weekCommitGraph[index].layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
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
            $0.centerY.equalToSuperview().multipliedBy(0.27)
        }
        
        
        bioLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.left.equalTo(profileImage.snp.right).offset(10)
            $0.top.equalTo(nameLabel.snp.bottom).offset(6)
            $0.height.equalTo(profileImage.snp.height).multipliedBy(1.2)
        }
        //  bioLabel.sizeToFit()
        
        todayLabel.snp.makeConstraints {
            $0.left.equalTo(profileImage.snp.left)
            $0.centerY.equalToSuperview().multipliedBy(0.56)
        }
        dailyCommitsLabel.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.14)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.72)
        }
        weekLabel.snp.makeConstraints {
            $0.left.equalTo(profileImage.snp.left)
            $0.centerY.equalToSuperview().multipliedBy(0.88)
        }
        
        //Week Commits View
        var currentCenterXMulitplier = 0.15
        for i in 0..<7 {
            weekCommitGraph[i].snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.11)
                $0.height.equalTo(weekCommitGraph[0].snp.width)
                $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
                $0.centerY.equalToSuperview().multipliedBy(1.02)
                currentCenterXMulitplier += 0.2835
            }
        }
        currentStreakLabel.snp.makeConstraints {
            $0.left.equalTo(profileImage.snp.left)
            $0.centerY.equalToSuperview().multipliedBy(1.18)
        }
        currentStreakCommitsLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.34)
        }
        
        longestStreakLabel.snp.makeConstraints {
            $0.left.equalTo(profileImage.snp.left)
            $0.centerY.equalToSuperview().multipliedBy(1.50)
        }
        longestStreakCommitsLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.66)
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
        // view.image = #imageLiteral(resourceName: "sampleIcon")
        
        view.image = ReadUserInfoHelper.shared.loadImageFromDiskWith(fileName: "ProfilePic")
        
        return view
        
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40.0, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.text = ""
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        if Constants.isIpad == false {
            label.font = UIFont.systemFont(ofSize: 20.0)
        } else {
            label.font = UIFont.systemFont(ofSize: 30.0)
        }
        
        label.adjustsFontSizeToFitWidth = false
        label.text = ""
        label.numberOfLines = 4
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.6)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    //TODAY VIEW
    lazy var todayLabel: UILabel = createTitleText(text: "Today")
    
    let dailyCommitsLabel: UILabel = {
        let label = UILabel()
        if Constants.isIpad == false {
            label.font = UIFont.systemFont(ofSize: 60.0, weight: .bold)
        } else {
            label.font = UIFont.systemFont(ofSize: 70.0, weight: .bold)
        }
        
        label.adjustsFontSizeToFitWidth = true
        
        if (UserDefaults.standard.object(forKey: "DailyCommits") != nil) {
            label.text = String(UserDefaults.standard.integer(forKey: "DailyCommits"))
        } else {
            label.text = "0"
        }
        
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    //THIS WEEK VIEW
    lazy var weekLabel: UILabel = createTitleText(text: "This Week")
    
    var weekCommitGraph = [UIView]()
    
    public func setupWeekGrass() {
        for i in 0..<7 {
            weekCommitGraph.append(createGraphNodeView())
            addSubview(weekCommitGraph[i])
        }
    }
    
    internal func createGraphNodeView() -> UIView {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return view
    }
    
    //CURRENT STREAK VIEW
    lazy var currentStreakLabel: UILabel = createTitleText(text: "Current Streak")
    
    let currentStreakCommitsLabel: UILabel = {
        let label = UILabel()
        if Constants.isIpad == false {
            label.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
        } else {
            label.font = UIFont.systemFont(ofSize: 50.0, weight: .bold)
        }
        label.adjustsFontSizeToFitWidth = true
        if (UserDefaults.standard.object(forKey: "CurrentStreak") != nil) {
            label.text = String(UserDefaults.standard.integer(forKey: "CurrentStreak")) + " days 🔥"
        } else {
            label.text = "0 days 🔥"
        }
        
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    //LONGEST STREAK VIEW
    lazy var longestStreakLabel: UILabel = createTitleText(text: "Longest Streak")
    
    let longestStreakCommitsLabel: UILabel = {
        let label = UILabel()
        if Constants.isIpad == false {
            label.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
        } else {
            label.font = UIFont.systemFont(ofSize: 50.0, weight: .bold)
        }
        label.adjustsFontSizeToFitWidth = true
        if (UserDefaults.standard.object(forKey: "LongestStreak") != nil) {
            label.text = String(UserDefaults.standard.integer(forKey: "LongestStreak")) + " days 🔥"
        } else {
            label.text = "0 days 🔥"
        }
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    
    internal func createTitleText(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "\(text)"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.6)
        return label
    }
    
    
    
}

