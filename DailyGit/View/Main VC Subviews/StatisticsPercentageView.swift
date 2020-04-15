//
//  StatisticsPercentageView.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/11/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


enum StatPercentType {
    case percent, number
}

public class StatisticsPercentageView: UIView {
    var thisStat: AverageType
    var viewType: StatPercentType = .percent
    
    init(averageType: AverageType) {
        self.thisStat = averageType
        super.init(frame: CGRect.zero)
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.cornerRadius = 15
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setupView() {
        initializeUI()
        setupLabels()
        createConstraints()
    }
    
    private func initializeUI() {
        addSubview(topLabel)
        addSubview(percentageNumber)
        addSubview(bottomLabel)
    }
    
    public func createConstraints() {
        percentageNumber.snp.makeConstraints{
            $0.centerY.equalToSuperview().multipliedBy(1.1)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        bottomLabel.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(10)
        }
        
        topLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.left.equalTo(bottomLabel.snp.left)
            
           if Constants.screenHeight > 1000 {
             $0.centerY.equalToSuperview().multipliedBy(0.2)
           } else {
             $0.centerY.equalToSuperview().multipliedBy(0.35)
            }
        }
        
        if Constants.screenHeight < 600 {
            bottomLabel.snp.remakeConstraints{
                $0.bottom.equalToSuperview().inset(5)
                $0.left.equalToSuperview().inset(5)
            }
        }
    }
    
    public let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.scaledFont(textStyle: .headline, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.text = ""
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    public let percentageNumber: UILabel = {
        let label = UILabel()
        label.font = UIFont.scaledFont(textStyle: .subheadline, weight: .regular)
        print(label.font ?? "Font can't be found")
        label.adjustsFontForContentSizeCategory = true
        label.text = "0%"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textColor = UserInfoHelper.shared.getStreakColor(commits: 0)
        return label
    }()
    
    public let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.scaledFont(textStyle: .headline, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.text = "of the days!"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    
    public func setupLabels() {
        changeNum()
    }
    
    func changeNum() {
        var percent = 0
        if thisStat == .weekly {
            topLabel.text = "This week, you've had a contribution:"
            percent = StatisticsHelper.shared.weeklyPercent()
        } else {
            topLabel.text = "This month, you've had a contribution:"
            percent = StatisticsHelper.shared.monthlyPercent()
        }
        
        if viewType == .number {
            var stats = (0,0)
            if thisStat == .weekly {
                stats = StatisticsHelper.shared.weeklyDays()
            } else {
                stats = StatisticsHelper.shared.monthlyDays()
            }
            percentageNumber.text = String(stats.0) + "/" + String(stats.1)
            percentageNumber.textColor = StatisticsHelper.shared.getPercentageColor(num: percent)
        } else {
            percentageNumber.text = String(percent) + "%"
            percentageNumber.textColor = StatisticsHelper.shared.getPercentageColor(num: percent)
        }
    }
}
