//
//  ContributionsGraphView.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/28/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation
import SnapKit

public class ContributionsGraphView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.zero
        initializeUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeUI() {
        
    }
    
    //TODO: Add Graph
    /*
     This is going to be used to add the graph to the top view, find 3rd party library to create graph, use data pulled from Github
 */
    

}
