//
//  WeeklySubView.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/2/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum WeekType {
    case currentWeek, lastWeek
}

enum WeekViewType {
    case week, month
}

public class WeeklySubView: CurvedView {
    var thisWeek: WeekType
    var viewType: WeekViewType = .week
    var monthCount = 30
    var extra = 0
    
    init(week: WeekType) {
        self.thisWeek = week
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setupView() {
        initializeUI()
        createConstraints()
        setupColorsForWeek()
    }
    
    private func initializeUI() {
        addViews()
    }
    
    public func createConstraints() {
        var currentCenterXMulitplier = 0.16
        for i in 0..<7 {
            commits[i].snp.makeConstraints {
                $0.height.equalToSuperview().multipliedBy(0.73)
                $0.width.equalTo(commits[0].snp.height)
                $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
                $0.centerY.equalToSuperview()
                currentCenterXMulitplier += 0.28
            }
        }
    }
    
    func addViews() {
        commits = []
        for v in self.subviews{
            v.removeFromSuperview()
        }
        
        
        if viewType == .month {
            var temp = 30
            if thisWeek == .currentWeek {
                if let contributions = UserInfoHelper.shared.readInfo(info: .currentMonth) as? ContributionList {
                    extra = contributions.contributions[0].dayOfWeek
                    
                }
                temp = DateHelper.shared.getNumberOfDaysInCurrentMonth() + extra
                
            } else {
                if let contributions = UserInfoHelper.shared.readInfo(info: .lastMonth) as? ContributionList {
                    extra = contributions.contributions[0].dayOfWeek
                    temp = contributions.contributions.count + extra
                }
            }
            for i in 0..<temp {
                commits.append(createGraphNodeView())
                addSubview(commits[i])
            }
            monthCount = temp
        } else {
            for i in 0..<7 {
                commits.append(createGraphNodeView())
                addSubview(commits[i])
            }
        }
    }
    
    var commits = [UIView]()
    
    func setupColorsForWeek() {
        addViews()
        if viewType == .month {
            var infoToGet: Userinfo
            if thisWeek == .currentWeek {
                infoToGet = .currentMonth
            } else {
                infoToGet = .lastMonth
            }
            
            var count = 5.0
            
            if let contributions = UserInfoHelper.shared.readInfo(info: infoToGet) as? ContributionList {
                print(extra)
                for (index, element) in contributions.contributions.enumerated() {
                    if extra > 0 {
                        let myColor = element.color.getColor()
                        commits[index+extra].backgroundColor = myColor
                    } else {
                        let myColor = element.color.getColor()
                        commits[index].backgroundColor = myColor
                    }
                }
                
                count = Double(contributions.contributions.count)/7.0
                count = count.rounded(.up)
            }
            
            for i in 0..<extra {
                commits[i].backgroundColor = #colorLiteral(red: 0.8313269555, green: 0.9000958616, blue: 1, alpha: 0)
            }
            
            var currentCenterXMulitplier = 0.16
            
            for i in 0..<7 {
                commits[i].snp.remakeConstraints {
                    $0.height.equalToSuperview().multipliedBy(0.18)
                    $0.width.equalTo(commits[0].snp.height)
                    $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
                    $0.top.equalToSuperview().offset(7)
                    currentCenterXMulitplier += 0.28
                }
            }
            currentCenterXMulitplier = 0.16
            
            for i in 7..<14 {
                commits[i].snp.remakeConstraints {
                    $0.height.equalToSuperview().multipliedBy(0.18)
                    $0.width.equalTo(commits[0].snp.height)
                    $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
                    $0.top.equalTo(commits[0].snp.bottom).multipliedBy(1.045)
                    currentCenterXMulitplier += 0.28
                }
            }
            
            currentCenterXMulitplier = 0.16
            
            for i in 14..<21 {
                commits[i].snp.remakeConstraints {
                    $0.height.equalToSuperview().multipliedBy(0.18)
                    $0.width.equalTo(commits[0].snp.height)
                    $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
                    $0.top.equalTo(commits[7].snp.bottom).multipliedBy(1.015)
                    currentCenterXMulitplier += 0.28
                }
            }
            
            currentCenterXMulitplier = 0.16
            
            for i in 21..<28 {
                commits[i].snp.remakeConstraints {
                    $0.height.equalToSuperview().multipliedBy(0.18)
                    $0.width.equalTo(commits[0].snp.height)
                    $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
                    $0.top.equalTo(commits[15].snp.bottom).multipliedBy(1.015)
                    currentCenterXMulitplier += 0.28
                }
            }
            
            currentCenterXMulitplier = 0.16
            
            if commits.count >= 28 {
                for i in 28..<commits.count {
                    commits[i].snp.remakeConstraints {
                        $0.height.equalToSuperview().multipliedBy(0.18)
                        $0.width.equalTo(commits[0].snp.height)
                        $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
                        $0.top.equalTo(commits[22].snp.bottom).multipliedBy(1.015)
                        currentCenterXMulitplier += 0.28
                    }
                }
            }
            
            
            
        } else {
            var infoToGet: Userinfo
            if thisWeek == .currentWeek {
                infoToGet = .currentWeek
            } else {
                infoToGet = .lastWeek
            }
            
            if let contributions = UserInfoHelper.shared.readInfo(info: infoToGet) as? ContributionList {
                for (index, element) in contributions.contributions.enumerated() {
                    let myColor = element.color.getColor()
                    commits[index].backgroundColor = myColor
                    
                }
            }
            
            var currentCenterXMulitplier = 0.16
            for i in 0..<7 {
                commits[i].snp.remakeConstraints {
                    $0.height.equalToSuperview().multipliedBy(0.73)
                    $0.width.equalTo(commits[0].snp.height)
                    $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
                    $0.centerY.equalToSuperview()
                    currentCenterXMulitplier += 0.28
                }
            }
        }
        
    }
    
    internal func createGraphNodeView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: Int("ebedf0", radix: 16)!)
        return view
    }
    
}
