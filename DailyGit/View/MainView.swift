//
//  MainView.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 2/28/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation
import SnapKit
//import ChamelonFramework

public class MainView: UIView {
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
        addSubview(topView)
        addSubview(middleView)
        addSubview(bottomView)
        
    }
    
    public func createConstraints() {
        
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
        let coloredView = UIView()
        coloredView.contentMode = UIView.ContentMode.scaleAspectFill
        coloredView.clipsToBounds = true
        coloredView.translatesAutoresizingMaskIntoConstraints = false
        return coloredView
    }()
    
    public let bottomView: UIView = {
        let coloredView = UIView()
        coloredView.contentMode = UIView.ContentMode.scaleAspectFill
        coloredView.clipsToBounds = true
        coloredView.translatesAutoresizingMaskIntoConstraints = false
        return coloredView
    }()
    
    //Subviews
    public let graphView: UIImageView = {
        let graphImage = UIImage(named: "3DGIRL.gif")
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = graphImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}
