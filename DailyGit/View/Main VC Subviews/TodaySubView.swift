//
//  TodaySubView.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/2/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


enum StreakStatus {
    case longest, current
}


public class TodaySubView: CurvedView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setupView() {
        initializeUI()
        setNumberLabels(user: UserInfoHelper.shared.readInfo(info: .user) as? User ?? User(name: "", username: "", bio: "", photoUrl: "", dateCreated: "", yearCreated: 2020, contributions: ContributionList(contributions: [])))
        createConstraints()
    }
    
    private func initializeUI() {
        addSubview(yesterdayCommits)
        addSubview(yesterdayLabel)
        
        addSubview(firstDivider)
        
        addSubview(todayCommits)
        addSubview(todayLabel)
        
        addSubview(secondDivider)
        
        addSubview(currentStreak)
        addSubview(currentStreakLabel)
    }
    
    public func createConstraints() {
        
        yesterdayCommits.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.33333)
            $0.left.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
            $0.centerY.equalToSuperview().multipliedBy(0.8)
        }
        
        yesterdayLabel.snp.makeConstraints{
            $0.width.equalTo(yesterdayCommits.snp.width)
            $0.left.equalToSuperview()
            $0.top.equalTo(yesterdayCommits.snp.bottom)
        }
        
        firstDivider.snp.makeConstraints {
            $0.top.equalTo(yesterdayCommits.snp.top).offset(5)
            $0.bottom.equalTo(yesterdayLabel.snp.bottom).inset(3)
            $0.left.equalTo(yesterdayLabel.snp.right)
            $0.width.equalToSuperview().multipliedBy(0.0007)
        }
        
        todayCommits.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.33333)
            $0.left.equalTo(firstDivider.snp.right)
            $0.height.equalTo(yesterdayCommits.snp.height)
            $0.centerY.equalToSuperview().multipliedBy(0.8)
        }
        todayLabel.snp.makeConstraints{
            $0.width.equalTo(todayCommits.snp.width)
            $0.left.equalTo(todayCommits.snp.left)
            $0.top.equalTo(todayCommits.snp.bottom)
        }
        
        secondDivider.snp.makeConstraints {
            $0.top.equalTo(yesterdayCommits.snp.top).inset(5)
            $0.bottom.equalTo(yesterdayLabel.snp.bottom).inset(3)
            $0.left.equalTo(todayLabel.snp.right)
            $0.width.equalToSuperview().multipliedBy(0.0007)
        }
        
        currentStreak.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.33333)
            $0.left.equalTo(secondDivider.snp.right)
            $0.height.equalTo(yesterdayCommits.snp.height)
            $0.centerY.equalToSuperview().multipliedBy(0.8)
        }
        currentStreakLabel.snp.makeConstraints{
            $0.width.equalTo(currentStreak.snp.width)
            $0.left.equalTo(currentStreak.snp.left)
            $0.top.equalTo(yesterdayCommits.snp.bottom)
        }
        
    }
    
    let noCommitsColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9411764706, alpha: 1)
    
    // Yesterday
    public lazy var yesterdayCommits = createNumberLabel(text: "0")
    public lazy var yesterdayLabel = createLabel(text: "Yesterday")
    
    public lazy var firstDivider = createDivider()
    
    // Today
    public lazy var todayCommits = createNumberLabel(text: "0")
    public lazy var todayLabel = createLabel(text: "Today")
    
    public lazy var secondDivider = createDivider()
    
    // Current Streak
    public lazy var currentStreak = createNumberLabel(text: "0")
    public lazy var currentStreakLabel = createLabel(text: "Current Streak")
    
    
    func createNumberLabel(text: String) -> UILabel {
        let label = UILabel()
        // The valid value range is from -1.0 to 1.0. The value of 0.0 corresponds to the regular or medium font weight
        //UIFont.Weight(rawValue: -0.5)
        label.font = UIFont.scaledFont(textStyle: .subheadline, weight: .regular)
        
        #warning("This is printing 3 times which indicates the view is being loaded 3 times...weird.")
        print(label.font ?? "Font can't be found")
        label.adjustsFontForContentSizeCategory = true
        label.text = text
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textColor = noCommitsColor
        //label.textColor = #colorLiteral(red: 0.4784313725, green: 0.768627451, blue: 0.4117647059, alpha: 1)
        return label
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.scaledFont(textStyle: .headline, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.text = text
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        // label.textColor = Constants.subTitleColor
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }
    
    func setNumberLabels(user: User) {
        
        
        if let todayContribution = user.contributions.contributions.last {
            todayCommits.text = String(todayContribution.count)
            todayCommits.textColor = todayContribution.color.getColor()
        }
        
        let count = user.contributions.contributions.count
        if count > 3 {
            
            let cont = user.contributions.contributions[count-2]
            yesterdayCommits.text = String(cont.count)
            yesterdayCommits.textColor = cont.color.getColor()
        }
        
        
        
        if Constants.streakStatus == .current {
            currentStreakLabel.text = "Current Streak"
            
            currentStreak.text = String(user.currentStreak)
            currentStreak.textColor = UserInfoHelper.shared.getStreakColor(commits: user.currentStreak)
            
        } else {
            currentStreakLabel.text = "Longest Streak"
            currentStreak.text = String(user.longestStreak)
            currentStreak.textColor = UserInfoHelper.shared.getStreakColor(commits: user.longestStreak)
        }
        
        
        
    }
    
    func changeStreak() {
        if Constants.streakStatus == .current {
            currentStreakLabel.text = "Current Streak"
            if let currentStreakNum = UserInfoHelper.shared.readInfo(info: .currentStreak) as? Int {
                currentStreak.text = String(currentStreakNum)
                currentStreak.textColor = UserInfoHelper.shared.getStreakColor(commits: currentStreakNum)
            } else {
                currentStreak.text = String(0)
                currentStreak.textColor = UserInfoHelper.shared.getStreakColor(commits: 0)
            }
        } else {
            currentStreakLabel.text = "Longest Streak"
            if let longestStreakNum = UserInfoHelper.shared.readInfo(info: .longestStreak) as? Int {
                currentStreak.text = String(longestStreakNum)
                currentStreak.textColor = UserInfoHelper.shared.getStreakColor(commits: longestStreakNum)
            }
        }
    }
    
    
    func createDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return view
    }
}
