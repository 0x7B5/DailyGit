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

public class WeeklySubView: CurvedView {
    var thisWeek: WeekType
    
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
        for i in 0..<7 {
            commits.append(createGraphNodeView())
            addSubview(commits[i])
        }
    }
    
    public func createConstraints() {
        var currentCenterXMulitplier = 0.16
        for i in 0..<7 {
            commits[i].snp.makeConstraints {
                $0.height.equalToSuperview().multipliedBy(0.7)
                $0.width.equalTo(commits[0].snp.height)
                $0.centerX.equalToSuperview().multipliedBy(currentCenterXMulitplier)
                $0.centerY.equalToSuperview()
                currentCenterXMulitplier += 0.28
            }
        }
    }
    
    var commits = [UIView]()
    
    func setupColorsForWeek() {
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
    }
    
    internal func createGraphNodeView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: Int("ebedf0", radix: 16)!)
        return view
    }
    
}
