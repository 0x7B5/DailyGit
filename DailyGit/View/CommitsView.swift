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
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.zero
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
        view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return view
    }()
    
}
