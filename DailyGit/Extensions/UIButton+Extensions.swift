//
//  UIButton+Extensions.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 3/31/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit

class myButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? #colorLiteral(red: 0, green: 0.338881232, blue: 0.5862944162, alpha: 1) : Constants.blueColor
        }
    }
}
