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


public class StatisticsPercentageView: UIView {
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
        }
        
        bottomLabel.snp.makeConstraints{
//            $0.top.equalTo(percentageNumber.snp.bottom)
            $0.bottom.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview().multipliedBy(0.65)
        }
        
        topLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.centerY.equalToSuperview().multipliedBy(0.35)
            $0.left.equalTo(bottomLabel.snp.left)
        }
    }
    
    public let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.scaledFont(textStyle: .headline, weight: .regular)
        label.adjustsFontForContentSizeCategory = true
        label.text = ""
        label.numberOfLines = 2
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
        if thisStat == .weekly {
            topLabel.text = "This week, you've had a contribution:"
        } else {
            topLabel.text = "This month, you've had a contribution:"
        }
    }
    
}
