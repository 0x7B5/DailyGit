//
//  UIView+Extensions.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/3/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addShadowToView(shadowOpacity: Float, shadowRadius: CGFloat) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = shadowOpacity
        // 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = shadowRadius
        //2
    }
    
    func makeCurved(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
}
