//
//  UIFont+UILabel+Extensions.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 3/31/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

extension UIFont {

    /// Scaled and styled version of any custom Font
    ///
    /// - Parameters:
    ///   - name: Name of the Font
    ///   - textStyle: The text style i.e Body, Title, ...
    /// - Returns: The scaled custom Font version with the given textStyle
    static func scaledFont(textStyle: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {

        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        
        var scaler: CGFloat = 1.0
        if textStyle == .subheadline {
            scaler = 4.0
        } else if textStyle == .headline {
            if Constants.screenHeight < 736 {
                scaler = 0.9
            } else {
                scaler = 0.95
            }
        }
        
        let customFont = UIFont.systemFont(ofSize: fontDescriptor.pointSize * scaler, weight: weight)

        return UIFontMetrics.default.scaledFont(for: customFont)
    }
}
