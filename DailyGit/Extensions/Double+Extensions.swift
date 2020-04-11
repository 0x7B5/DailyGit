//
//  Double+Extensions.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/10/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
