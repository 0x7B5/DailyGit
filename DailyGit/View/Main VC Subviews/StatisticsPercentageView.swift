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
        createConstraints()
    }
    
    private func initializeUI() {
        
    }
    
    public func createConstraints() {
        
    }
    
    public let averageCommitsNumber: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.scaledFont(textStyle: .subheadline, weight: .regular)
        print(label.font ?? "Font can't be found")
        label.adjustsFontForContentSizeCategory = true
        label.text = ""
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textColor = UserInfoHelper.shared.getStreakColor(commits: 0)
        return label
    }()
    
}
