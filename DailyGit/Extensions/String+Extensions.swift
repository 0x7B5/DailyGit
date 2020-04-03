//
//  String+Extensions.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/27/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    subscript(value: Int) -> Character {
        self[index(at: value)]
    }
}

public extension String {
    subscript(value: NSRange) -> Substring {
        self[value.lowerBound..<value.upperBound]
    }
}

public extension String {
    subscript(value: CountableClosedRange<Int>) -> Substring {
        self[index(at: value.lowerBound)...index(at: value.upperBound)]
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        self[index(at: value.lowerBound)..<index(at: value.upperBound)]
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        self[..<index(at: value.upperBound)]
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        self[...index(at: value.upperBound)]
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        self[index(at: value.lowerBound)...]
    }
    
    func getColor() -> UIColor {
        return UIColor(rgb: (Int(self[1...], radix: 16) ?? 0xEBEDF0))
    }
}

private extension String {
    func index(at offset: Int) -> String.Index {
        index(startIndex, offsetBy: offset)
    }
}
