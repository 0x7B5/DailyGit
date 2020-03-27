//
//  Textfield+Extensions.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 3/27/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
  func setBottomBorder() {
    self.borderStyle = .none
    self.layer.backgroundColor = Constants.mainBGColor?.cgColor

    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
  }
}
