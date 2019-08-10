//
//  SettingView.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/10/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit
import SnapKit

public class SettingView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.zero
        initializeUI()
        createConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeUI() {
        //UIViews
        // addSubview(topView)
        addSubview(middleView)
        
        
    }
    
    public func createConstraints() {
        middleView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.3)
            $0.width.equalToSuperview()
            $0.top.equalToSuperview()
            
        }
    }
    
    //TODO: Create Custom UIViews for these Views
    
    //SUBVIEWS
    public let topView: ContributionsGraphView = {
        let graphView = ContributionsGraphView()
        graphView.contentMode = UIView.ContentMode.scaleAspectFill
        graphView.clipsToBounds = true
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()
    
    
    public let middleView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return view
    }()
}
