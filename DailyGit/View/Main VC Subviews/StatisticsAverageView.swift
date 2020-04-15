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

enum StatAvgViewType {
    case average, percent
}

public class StatisticsAverageView: UIView {
    var thisStat: AverageType
    var viewType: StatAvgViewType = .average
    
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
        addSubview(topLabel)
        addSubview(bottomLabel)
    }
    
    public func createConstraints() {
        averageCommitsNumber.snp.makeConstraints{
            $0.centerY.equalToSuperview().multipliedBy(0.9)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        bottomLabel.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(10)
        }
        
        topLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.centerY.equalToSuperview().multipliedBy(0.2)
            $0.left.equalTo(bottomLabel.snp.left)
        }
        
        if Constants.screenHeight < 600 {
            bottomLabel.snp.remakeConstraints{
                $0.bottom.equalToSuperview().inset(5)
                $0.left.equalToSuperview().inset(5)
            }
        }
    }
    
    public let averageCommitsNumber: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.scaledFont(textStyle: .subheadline, weight: .regular)
        print(label.font ?? "Font can't be found")
        label.adjustsFontForContentSizeCategory = true
        label.text = "16"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textColor = UserInfoHelper.shared.getStreakColor(commits: 0)
        return label
    }()
    
    #warning("Make this smaller and bolder")
    public let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.scaledFont(textStyle: .headline, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.text = "contributions per day, this week"
        
        if Constants.screenHeight > 1000 {
            label.numberOfLines = 1
        } else {
            label.numberOfLines = 2
        }
        
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    public let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.scaledFont(textStyle: .headline, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.text = "Average of:"
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
        changeNum()
    }
    
    func changeNum() {
        var temp: (Double, Double)
        if thisStat == .weekly {
            temp = StatisticsHelper.shared.weeklyAverage()
        } else {
            temp = StatisticsHelper.shared.monthlyAverage()
        }
        
        if self.viewType == .average {
            topLabel.text = "Average of:"
            
            
            if Constants.screenHeight > 1000 {
                if thisStat == .weekly {
                    bottomLabel.text = "contributions per day, this week"
                } else {
                    bottomLabel.text = "contributions per day, this month"
                }
            } else {
                if thisStat == .weekly {
                    bottomLabel.text = "contributions per day,\nthis week"
                } else {
                    bottomLabel.text = "contributions per day,\nthis month"
                }
            }
            averageCommitsNumber.text = String(temp.0)
            averageCommitsNumber.textColor = StatisticsHelper.shared.getColor(commits: temp.0)
        } else {
            averageCommitsNumber.text = String(temp.1) + "%"
            averageCommitsNumber.textColor = StatisticsHelper.shared.getPercentColor(num: temp.1)
            if temp.1 > 0.0 {
                topLabel.text = "Up:"
            } else {
                topLabel.text = "Down:"
            }
            
            if thisStat == .weekly {
                bottomLabel.text = "from last week"
            } else {
                bottomLabel.text = "from last month"
            }
            
        }
    }
}
