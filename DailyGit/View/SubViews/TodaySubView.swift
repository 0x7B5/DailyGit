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
        createConstraints()
    }
    
    private func initializeUI() {
        setupLabelDefaults()
        addSubview(yesterdayCommits)
        addSubview(yesterdayLabel)
        
        addSubview(todayCommits)
        addSubview(todayLabel)
        
        addSubview(currentStreak)
        addSubview(currentStreakLabel)
    }
    
    public func createConstraints() {
        yesterdayCommits.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.left.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
            $0.centerY.equalToSuperview().multipliedBy(0.7)
        }
        yesterdayLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.left.equalToSuperview()
            $0.top.equalTo(yesterdayCommits.snp.bottom)
        }
        
    }
    
    // Yesterday
    public lazy var yesterdayCommits = createNumberLabel(text: "0")
    public lazy var yesterdayLabel = createLabel(text: "Yesterday")
    
    public let firstDivider: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    // Today
    public lazy var todayCommits = createNumberLabel(text: "0")
    public lazy var todayLabel = createLabel(text: "Today")
    
    // Current Streak
    public lazy var currentStreak = createNumberLabel(text: "0")
    public lazy var currentStreakLabel = createLabel(text: "Current Streak")
    
    
    func createNumberLabel(text: String) -> UILabel {
        let label = UILabel()
        #warning("Find Dynamic font solution")
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.text = text
        label.textAlignment = .center
        //label.adjustsFontSizeToFitWidth = true
        //label.minimumScaleFactor = 0.2
        
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.text = text
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }
    
    func setupLabelDefaults() {
        if (UserDefaults.standard.object(forKey: "DailyCommits") != nil) {
            todayCommits.text = String(UserDefaults.standard.integer(forKey: "DailyCommits"))
        }
        
        if (UserDefaults.standard.object(forKey: "YesterdayCommits") != nil) {
            yesterdayCommits.text = String(UserDefaults.standard.integer(forKey: "YesterdayCommits"))
        }
        
        if (UserDefaults.standard.object(forKey: "CurrentStreak") != nil) {
            currentStreak.text = String(UserDefaults.standard.integer(forKey: "CurrentStreak"))
        }
        
    }
    
    func calculateColor(commits: Int) -> UIColor {
        
        return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
