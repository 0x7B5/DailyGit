//
//  AutoUpdater.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 4/8/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation
public class AutoUpdater {
    static let shared = AutoUpdater()
    var timer: DispatchSourceTimer?
    
    func startTimer() {
        let queue = DispatchQueue(label: "com.DailyGit.timer")  // you can also use `DispatchQueue.main`, if you want
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(Constants.refreshRatePerSecond))
        timer!.setEventHandler { [weak self] in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        }
        timer!.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
        print("Timmer Stopped")
    }
    
    deinit {
        self.stopTimer()
        print("Timmer Stopped")
    }
}
