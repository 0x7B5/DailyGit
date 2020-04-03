//
//  UIImage+Extensions.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/2/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import UIKit

extension UIImageView {
    func makeRounded(frameSize: CGFloat) {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = (frameSize * Constants.profileImageWidth)/2
        self.clipsToBounds = true
    }
}
