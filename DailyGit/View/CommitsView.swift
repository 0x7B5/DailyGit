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
    // topLayout: CGFloat
    
    #warning("Take out filler info.")
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
        
        // This Week
        addSubview(weekLabel)
        addSubview(weekView)
        
        // setupWeekGrass()
        
        // Last Week
        addSubview(lastWeekLabel)
        addSubview(lastWeekView)
        
        // Statistics
        addSubview(stasticsLabel)
        addSubview(statView)
        statView.addSubview(dailyAvgView)
        statView.addSubview(weeklyAvgView)
        statView.addSubview(monthlyAvgView)
        
        
        //Bottom
        addSubview(lastUpdatedLabel)
    }
    
    
    public func createConstraints() {
        
        
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
            $0.height.equalToSuperview().multipliedBy(0.17)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(topView.snp.bottom).multipliedBy(0.98)
        }
        
        addShadowToView(view: todayView)
        
        // CURRENT WEEK
        weekLabel.snp.makeConstraints {
            $0.left.equalTo(topView.nameLabel.snp.left)
            $0.top.equalTo(todayView.snp.bottom).offset(15)
        }
        
        weekView.snp.makeConstraints {
            $0.width.equalTo(todayView.snp.width)
            $0.height.equalToSuperview().multipliedBy(0.09)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(weekLabel.snp.bottom).offset(3)
        }
        
        addShadowToView(view: weekView)
        
        // LAST WEEK
        lastWeekLabel.snp.makeConstraints {
            $0.left.equalTo(topView.nameLabel.snp.left)
            $0.top.equalTo(weekView.snp.bottom).offset(20)
        }
        
        lastWeekView.snp.makeConstraints {
            $0.width.equalTo(todayView.snp.width)
            $0.height.equalTo(weekView.snp.height)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lastWeekLabel.snp.bottom).offset(3)
        }
        addShadowToView(view: lastWeekView)
        
        // LAST UPDATED LABEL
        lastUpdatedLabel.snp.makeConstraints{
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            
            if UIDevice.current.hasNotch {
                $0.bottom.equalToSuperview().inset(20)
            } else {
                $0.bottom.equalToSuperview().inset(10)
            }
        }
        
        // STATISTICS
        stasticsLabel.snp.makeConstraints {
            $0.left.equalTo(topView.nameLabel.snp.left)
            $0.top.equalTo(lastWeekView.snp.bottom).offset(20)
        }
        
        statView.snp.makeConstraints {
            $0.width.equalTo(todayView.snp.width)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stasticsLabel.snp.bottom).offset(3)
            $0.height.equalTo(todayView.snp.height).multipliedBy(1.25)
        }

        // DAILY AVERAGE
        dailyAvgView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.31)
        }
        addShadowToView(view: dailyAvgView)
               
        // WEEKLY AVERAGE
        weeklyAvgView.snp.makeConstraints {
            $0.height.equalTo(dailyAvgView.snp.height)
            $0.width.equalTo(dailyAvgView.snp.width)
            $0.centerX.equalToSuperview()
        }
        addShadowToView(view: weeklyAvgView)
               
        // MONTHLY AVERAGE
        monthlyAvgView.snp.makeConstraints {
            $0.height.equalTo(dailyAvgView.snp.height)
            $0.width.equalTo(dailyAvgView.snp.width)
            $0.right.equalToSuperview()
        }
        addShadowToView(view: monthlyAvgView)
        
        //Week Commits View
        
        //        var currentCenterXMulitplier = 0.15
        //        for i in 0..<7 {
        //            weekCommitGraph[i].snp.makeConstraints {
        //                $0.width.equalToSuperview().multipliedBy(0.11)
        //                $0.height.equalTo(weekCommitGraph[0].snp.width)
        //                $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
        //                $0.centerY.equalToSuperview().multipliedBy(1.02)
        //                currentCenterXMulitplier += 0.2835
        //            }
        //        }
        
        
    }
    
    //SUBVIEWS
    public let topView = MainTopView()
    
    //TODAY VIEW
    let todayView = TodaySubView()
    
    //THIS WEEK VIEW
    lazy var weekLabel: UILabel = createTitleText(text: "This Week")
    let weekView = CurvedView()
    
    var weekCommitGraph = [UIView]()
    
    public func setupWeekGrass() {
        for i in 0..<7 {
            weekCommitGraph.append(createGraphNodeView())
            addSubview(weekCommitGraph[i])
        }
    }
    
    internal func createGraphNodeView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: Int("ebedf0", radix: 16)!)
        return view
    }
    
    // LAST WEEK VIEW
    lazy var lastWeekLabel: UILabel = createTitleText(text: "Last Week")
    let lastWeekView = CurvedView()
   
    // STATISTICS
    lazy var stasticsLabel: UILabel = createTitleText(text: "Statistics")
    let statView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return view
    }()
    // DAILY AVERAGE
    let dailyAvgView = CurvedView()
           
    // WEEKLY AVERAGE
    let weeklyAvgView = CurvedView()
           
    // MONTHLY AVERAGE
    let monthlyAvgView = CurvedView()
    
    
    
    //BOTTOM VIEW
    #warning("Remove filler info")
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
        label.textColor = Constants.subTitleColor
        return label
    }
    
    internal func addShadowToView(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
    }
    
    
    func setupColorsForWeek(contributions: ContributionList) {
        
        for (index, element) in contributions.contributions.enumerated() {
            let myIndex = element.color.index(element.color.startIndex, offsetBy: 1)
            let mySubstring = element.color.suffix(from: myIndex)
            
            let myColor = UIColor(rgb: (Int(mySubstring, radix: 16) ?? 0))
            
            weekCommitGraph[index].backgroundColor = myColor
            if element.date == DateHelper.shared.getFormattedDate() {
                weekCommitGraph[index].layer.borderWidth = 0.5
                weekCommitGraph[index].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    func checkAllignmentForTitle() {
        if UserInfoHelper.shared.readInfo(info: .bio) as? String == "" {
            //            nameLabel.textAlignment = .center
            //            nameLabel.snp.makeConstraints{
            //                $0.width.equalToSuperview().multipliedBy(0.4)
            //                $0.centerX.equalToSuperview()
            //                $0.height.equalToSuperview().multipliedBy(0.045)
            //                $0.centerY.equalToSuperview().multipliedBy(0.34)
            //            }
        }
    }
}
