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
    
    init() {
        //  self.topLayout = topLayout
        super.init(frame: CGRect.zero)
        self.frame = CGRect.zero
        backgroundColor = Constants.whiteColor
        initializeUI()
        createConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeUI() {
        // Top View
        addSubview(topView)
        
        // Today
        addSubview(todayView)
        
        // addSubview(scrollView)
        
        // This Week
        addSubview(weekLabel)
        addSubview(weekView)
        
        // setupWeekGrass()
        
        // Last Week
        addSubview(lastWeekLabel)
        addSubview(lastWeekView)
        
        // Statistics
        addSubview(weeklyStatsLabel)
        addSubview(weeklyStatView)
        weeklyStatView.addSubview(weeklyAvgView)
        weeklyStatView.addSubview(weeklyPercentageView)
        addSubview(monthlyStatsLabel)
        addSubview(monthlyStatView)
        monthlyStatView.addSubview(monthlyAvgView)
        monthlyStatView.addSubview(monthlyPercentageView)
        //        statView.addSubview(monthlyAvgView)
        
        //Bottom
        addSubview(lastUpdatedLabel)
    }
    
    
    public func createConstraints() {
        setLastUpdatedLabel()
        var spacingConstant = 20
        var todayViewSpacingConstant = 0.98
        
        var weekLabelSpacingConstant = 15
        var weekViewHeightConstant = 0.08
        
        if Constants.screenHeight < 700 {
            spacingConstant = 10
            todayViewSpacingConstant = 0.9
            weekViewHeightConstant = 0.10
            
            if Constants.screenHeight < 600 {
                spacingConstant = 8
                weekLabelSpacingConstant = 10
            }
        }
        
        #warning("Change offset between views for iPhone 8 and Se")
        // TOP VIEW
        topView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.25)
            $0.centerX.equalToSuperview()
        }
        
        //TODAY VIEW
        
        todayView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.95)
            $0.height.equalToSuperview().multipliedBy(0.15)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(topView.snp.bottom).multipliedBy(todayViewSpacingConstant)
        }
        
        todayView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        
        // LAST UPDATED LABEL
        lastUpdatedLabel.snp.makeConstraints{
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            
            if UIDevice.current.hasNotch {
                $0.bottom.equalToSuperview().inset(spacingConstant)
            } else {
                $0.bottom.equalToSuperview().inset(10)
            }
        }
        
        //        scrollView.snp.makeConstraints{
        //            $0.width.equalToSuperview()
        //            $0.top.equalTo(todayView.snp.bottom).inset(10)
        //            $0.bottom.equalTo(lastUpdatedLabel.snp.top)
        //        }
        
        
        // CURRENT WEEK
        weekLabel.snp.makeConstraints {
            $0.left.equalTo(topView.nameLabel.snp.left)
            $0.top.equalTo(todayView.snp.bottom).offset(weekLabelSpacingConstant)
        }
        
        weekView.snp.makeConstraints {
            $0.width.equalTo(todayView.snp.width)
            $0.height.equalToSuperview().multipliedBy(weekViewHeightConstant)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(weekLabel.snp.bottom).offset(3)
        }
        
        weekView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        
        // LAST WEEK
        lastWeekLabel.snp.makeConstraints {
            $0.left.equalTo(topView.nameLabel.snp.left)
            $0.top.equalTo(weekView.snp.bottom).offset(spacingConstant)
        }
        
        lastWeekView.snp.makeConstraints {
            $0.width.equalTo(todayView.snp.width)
            $0.height.equalTo(weekView.snp.height)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lastWeekLabel.snp.bottom).offset(3)
        }
        lastWeekView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        
        
        // STATISTICS
        weeklyStatsLabel.snp.makeConstraints {
            $0.left.equalTo(topView.nameLabel.snp.left)
            $0.top.equalTo(lastWeekView.snp.bottom).offset(spacingConstant)
        }
        makeStatisticsView()
        
        // WEEKLY AVERAGE
        weeklyAvgView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.48)
            $0.left.equalToSuperview()
        }
        
        weeklyPercentageView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(weeklyAvgView.snp.width)
            $0.right.equalToSuperview()
        }
        
        // MONTHLY AVERAGE
        monthlyStatsLabel.snp.makeConstraints {
            $0.left.equalTo(topView.nameLabel.snp.left)
            $0.top.equalTo(weeklyStatView.snp.bottom).offset(spacingConstant)
        }
        
        monthlyStatView.snp.makeConstraints {
            $0.width.equalTo(todayView.snp.width)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(monthlyStatsLabel.snp.bottom).offset(3)
            $0.height.equalTo(weeklyStatView.snp.height)
        }
        
        monthlyAvgView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.48)
            $0.left.equalToSuperview()
        }
        
        monthlyPercentageView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(weeklyAvgView.snp.width)
            $0.right.equalToSuperview()
        }
        
        
        weeklyAvgView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        weeklyPercentageView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        
        monthlyAvgView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        monthlyPercentageView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        
        
    }
    
    //SUBVIEWS
    public let topView = MainTopView()
    
    //TODAY VIEW
    let todayView = TodaySubView()
    
    // Scroll View
    let scrollView = UIScrollView()
    
    //THIS WEEK VIEW
    lazy var weekLabel: UILabel = createTitleText(text: "This Week")
    let weekView = WeeklySubView(week: .currentWeek)
    
    // LAST WEEK VIEW
    lazy var lastWeekLabel: UILabel = createTitleText(text: "Last Week")
    let lastWeekView = WeeklySubView(week: .lastWeek)
    
    // STATISTICS
    lazy var weeklyStatsLabel: UILabel = createTitleText(text: "Weekly Statistics")
    lazy var monthlyStatsLabel: UILabel = createTitleText(text: "Monthly Statistics")
    let weeklyStatView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return view
    }()
    
    let monthlyStatView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return view
    }()
    
    // WEEKLY AVERAGE
    let weeklyAvgView = StatisticsAverageView(averageType: .weekly)
    let weeklyPercentageView = StatisticsPercentageView(averageType: .weekly)
    
    // MONTHLY AVERAGE
    let monthlyAvgView = StatisticsAverageView(averageType: .monthly)
    let monthlyPercentageView = StatisticsPercentageView(averageType: .monthly)
    
    //BOTTOM VIEW
    let lastUpdatedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.text = "Updated today at 2:19 AM"
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return label
        
    }()
    
    internal func createTitleText(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.scaledFont(textStyle: .title3, weight: .medium)
        label.adjustsFontForContentSizeCategory = true
        label.text = "\(text)"
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textColor = Constants.subTitleColor
        return label
    }
    
    func makeStatisticsView() {
        if Constants.screenHeight < 700 {
            weeklyStatView.snp.makeConstraints {
                $0.width.equalTo(todayView.snp.width)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(weeklyStatsLabel.snp.bottom).offset(3)
                $0.bottom.equalTo(lastUpdatedLabel.snp.top).offset(-6)
            }
        } else {
            weeklyStatView.snp.makeConstraints {
                $0.width.equalTo(todayView.snp.width)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(weeklyStatsLabel.snp.bottom).offset(3)
                $0.height.equalTo(todayView.snp.height).multipliedBy(1.25)
            }
        }
    }
    
    func setLastUpdatedLabel() {
        if let lastUpdated = UserInfoHelper.shared.readInfo(info: .updateTime) as? Date {
            lastUpdatedLabel.text = DateHelper.shared.getLastUpdatedText(myDate: lastUpdated)
        }
    }
    
}
