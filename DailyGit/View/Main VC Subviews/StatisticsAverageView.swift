//
//  StatisticsView.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/11/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum AverageType {
    case monthly, weekly
}

public class StatisticsAverageView: UIView {
    var thisStat: AverageType
    
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
        createConstraints()
        setupLabels()
    }
    
    private func initializeUI() {
        addSubview(averageCommitsNumber)
        addSubview(contributionsLabel)
        addSubview(percentLabel)
        addSubview(fromLabel)
    }
    
    public func createConstraints() {
        averageCommitsNumber.snp.makeConstraints{
            $0.width.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.6)
            $0.centerX.equalToSuperview().multipliedBy(1.13)
        }
        contributionsLabel.snp.makeConstraints{
            $0.width.equalToSuperview()
            $0.top.equalTo(averageCommitsNumber.snp.bottom).inset(10)
            $0.left.equalTo(averageCommitsNumber.snp.left)
        }
        percentLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.left.equalTo(contributionsLabel)
        }
        fromLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.left.equalTo(percentLabel.snp.right).offset(5)
        }
    }
    
    public let averageCommitsNumber: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.scaledFont(textStyle: .subheadline, weight: .regular)
        print(label.font ?? "Font can't be found")
        label.adjustsFontForContentSizeCategory = true
        label.text = "16"
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textColor = UserInfoHelper.shared.getStreakColor(commits: 0)
        return label
    }()
    
    #warning("Make this smaller and bolder")
    public let contributionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.scaledFont(textStyle: .headline, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.text = "contributions per day"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    public let percentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.scaledFont(textStyle: .headline, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.text = "0%"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    public let fromLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.scaledFont(textStyle: .headline, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.text = ""
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    public let arrowImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    
    public func setupLabels() {
        var temp: (Double, Double)
        if thisStat == .weekly {
            temp = StatisticsHelper.shared.weeklyAverage()
            fromLabel.text = "from last week"
        } else {
            temp = StatisticsHelper.shared.monthlyAverage()
            fromLabel.text = "from last month"
        }
        averageCommitsNumber.text = String(temp.0)
        averageCommitsNumber.textColor = StatisticsHelper.shared.getColor(commits: temp.0)
        
        percentLabel.text = String(temp.1) + "%"
        percentLabel.textColor = StatisticsHelper.shared.getPercentColor(num: temp.1)
    }
}
