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
    
    func rotate360Degrees(duration: CFTimeInterval = 2.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = -CGFloat(M_PI * 6.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as! CAAnimationDelegate
        }
        
        self.layer.add(rotateAnimation, forKey: nil)
    }
    

    
}


