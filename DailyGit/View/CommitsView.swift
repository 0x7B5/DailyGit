//
//  CommitsTest.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/12/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
import SnapKit

public class CommitsView: UIView {
    init() {
        super.init(frame: CGRect.zero)
        self.frame = CGRect.zero
        backgroundColor = Constants.whiteColor
        initializeUI()
        createConstraints()
        setLastUpdatedLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeUI() {
        // Top View
        addSubview(topView)
        // Today
        addSubview(todayView)
        addSubview(heightReferenceView)
        addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        
        // This Week
        scrollViewContainer.addArrangedSubview(currentWeekSuperView)
        currentWeekSuperView.addSubview(weekView)
        currentWeekSuperView.addSubview(weekLabel)
        
        // Last Week
        //lastWeekSuperView
        scrollViewContainer.addArrangedSubview(lastWeekSuperView)
        lastWeekSuperView.addSubview(lastWeekView)
        lastWeekSuperView.addSubview(lastWeekLabel)
        
        // Weekly Statistics
        scrollViewContainer.addArrangedSubview(weeklyStatView)
        weeklyStatView.addSubview(weeklyStatsLabel)
        weeklyStatView.addSubview(weeklyAvgView)
        weeklyStatView.addSubview(weeklyPercentageView)
        
        // Monthly Statistic
        scrollViewContainer.addArrangedSubview(monthlyStatView)
        monthlyStatView.addSubview(monthlyStatsLabel)
        monthlyStatView.addSubview(monthlyAvgView)
        monthlyStatView.addSubview(monthlyPercentageView)
        
        //Bottom
        addSubview(lastUpdatedLabel)
        
    }
    
    public func createConstraints() {
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
        
        // TOP VIEW
        topView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.25)
            $0.centerX.equalToSuperview()
        }
        
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
        
        //TODAY VIEW
        todayView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.95)
            $0.height.equalToSuperview().multipliedBy(0.15)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(topView.snp.bottom).multipliedBy(todayViewSpacingConstant)
        }
        
        
        heightReferenceView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(todayView.snp.bottom).inset(10)
            $0.bottom.equalTo(lastUpdatedLabel.snp.top)
        }
        todayView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        
        setupScrollView()
        
        // This Week
        currentWeekSuperView.snp.makeConstraints{
            $0.width.equalTo(todayView.snp.width)
            $0.height.equalTo(heightReferenceView.snp.height).multipliedBy(0.2)
        }
        weekLabel.snp.makeConstraints {
            $0.width.equalTo(todayView.snp.width)
            $0.left.equalTo(topView.nameLabel.snp.left)
            $0.top.equalTo(currentWeekSuperView.snp.top)
        }
        
        weekView.snp.makeConstraints {
            $0.width.equalTo(currentWeekSuperView.snp.width)
            $0.height.equalTo(currentWeekSuperView.snp.height).multipliedBy(0.65)
            $0.centerX.equalTo(heightReferenceView.snp.centerX)
            $0.bottom.equalTo(currentWeekSuperView.snp.bottom)
        }
        
        weekView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        
        // Last Week
        lastWeekSuperView.snp.makeConstraints{
            $0.width.equalTo(todayView.snp.width)
            $0.height.equalTo(heightReferenceView.snp.height).multipliedBy(0.2)
        }

        lastWeekLabel.snp.makeConstraints {
            $0.width.equalTo(todayView.snp.width)
            $0.left.equalTo(topView.nameLabel.snp.left)
            $0.top.equalTo(lastWeekSuperView.snp.top)
        }
        
        lastWeekView.snp.makeConstraints {
            $0.width.equalTo(lastWeekSuperView.snp.width)
            $0.height.equalTo(lastWeekSuperView.snp.height).multipliedBy(0.65)
            $0.centerX.equalTo(heightReferenceView.snp.centerX)
            $0.bottom.equalTo(lastWeekSuperView.snp.bottom)
        }
        lastWeekView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        
        // Weekly Average
        weeklyStatView.snp.makeConstraints {
            $0.width.equalTo(todayView.snp.width)
            $0.height.equalTo(heightReferenceView.snp.height).multipliedBy(0.38)
        }
        
        weeklyStatsLabel.snp.makeConstraints {
            $0.width.equalTo(todayView.snp.width)
            $0.left.equalTo(topView.nameLabel.snp.left)
            $0.top.equalTo(weeklyStatView.snp.top)
        }
        
        weeklyAvgView.snp.makeConstraints {
            $0.left.equalTo(topView.nameLabel.snp.left)
            $0.width.equalTo(weeklyStatView.snp.width).multipliedBy(0.48)
            $0.height.equalTo(weeklyStatView.snp.height).multipliedBy(0.8)
            $0.bottom.equalTo(weeklyStatView.snp.bottom)
        }
        
        weeklyPercentageView.snp.makeConstraints {
            $0.right.equalTo(todayView.snp.right)
            $0.width.equalTo(weeklyAvgView.snp.width)
            $0.height.equalTo(weeklyAvgView.snp.height)
            $0.bottom.equalTo(weeklyStatView.snp.bottom)
        }
        
        weeklyAvgView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        weeklyPercentageView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        
        // Monthly Average
        monthlyStatView.snp.makeConstraints {
            $0.width.equalTo(weeklyStatView.snp.width)
            $0.height.equalTo(weeklyStatView.snp.height)
        }

        monthlyStatsLabel.snp.makeConstraints {
            $0.width.equalTo(weeklyStatsLabel.snp.width)
            $0.left.equalTo(weeklyStatsLabel.snp.left)
            $0.top.equalTo(monthlyStatView.snp.top)
        }

        monthlyAvgView.snp.makeConstraints {
            $0.left.equalTo(topView.nameLabel.snp.left)
            $0.width.equalTo(monthlyStatView.snp.width).multipliedBy(0.48)
            $0.height.equalTo(monthlyStatView.snp.height).multipliedBy(0.8)
            $0.bottom.equalTo(monthlyStatView.snp.bottom)
        }

        monthlyPercentageView.snp.makeConstraints {
            $0.right.equalTo(todayView.snp.right)
            $0.width.equalTo(monthlyAvgView.snp.width)
            $0.height.equalTo(monthlyAvgView.snp.height)
            $0.bottom.equalTo(monthlyStatView.snp.bottom)
        }
        
        monthlyAvgView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        monthlyPercentageView.addShadowToView(shadowOpacity: 0.1, shadowRadius: 2)
        
        
    }
    
    //SUBVIEWS
    public let topView = MainTopView()
    
    //TODAY VIEW
    let todayView = TodaySubView()
    
    // Scroll View
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 10
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let heightReferenceView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return view
    }()
    
    //THIS WEEK VIEW
    lazy var weekLabel: UILabel = createTitleText(text: "This Week")
    let weekView = WeeklySubView(week: .currentWeek)
    
    let currentWeekSuperView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return view
    }()
    
    // LAST WEEK VIEW
    lazy var lastWeekLabel: UILabel = createTitleText(text: "Last Week")
    let lastWeekView = WeeklySubView(week: .lastWeek)
    
    let lastWeekSuperView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return view
    }()
    
    // Weekly Statistics
    lazy var weeklyStatsLabel: UILabel = createTitleText(text: "Weekly Statistics")
    let weeklyAvgView = StatisticsAverageView(averageType: .weekly)
    let weeklyPercentageView = StatisticsPercentageView(averageType: .weekly)
    
    let weeklyStatView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return view
    }()
    
    // Monthly Statistics
    lazy var monthlyStatsLabel: UILabel = createTitleText(text: "Monthly Statistics")
    let monthlyAvgView = StatisticsAverageView(averageType: .monthly)
    let monthlyPercentageView = StatisticsPercentageView(averageType: .monthly)
    
    let monthlyStatView: UIView = {
           let view = UIView()
           view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
           return view
       }()
    
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
    
    
    func setLastUpdatedLabel() {
        if let lastUpdated = UserInfoHelper.shared.readInfo(info: .updateTime) as? Date {
            lastUpdatedLabel.text = DateHelper.shared.getLastUpdatedText(myDate: lastUpdated)
        }
    }
    
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
    
    func setupScrollView() {
        scrollView.snp.makeConstraints{
            $0.width.equalToSuperview()
            $0.top.equalTo(todayView.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(lastUpdatedLabel.snp.top)
        }
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // this is important for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
}
