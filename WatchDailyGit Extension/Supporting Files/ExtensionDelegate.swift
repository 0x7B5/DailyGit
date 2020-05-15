//
//  ExtensionDelegate.swift
//  WatchDailyGit Extension
//
//  Created by Vlad Munteanu on 12/26/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        scheduleNextReload()
        DataGetter.shared.updateInfo(completion: {
            self.reloadActiveComplications()
        })
    }
    
    func scheduleNextReload() {
        let targetDate = nextReloadTime(after: Date())
        
        NSLog("ExtensionDelegate: scheduling next update at %@", "\(targetDate)")
        
        WKExtension.shared().scheduleBackgroundRefresh(
            withPreferredDate: targetDate,
            userInfo: nil,
            scheduledCompletion: { _ in }
        )
    }
    
    func nextReloadTime(after date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let targetMinutes = DateComponents(minute: 15)
        
        var nextReloadTime = calendar.nextDate(
            after: date,
            matching: targetMinutes,
            matchingPolicy: .nextTime
            )!
        
        // if it's in less than 5 minutes, then skip this one and try next hour
        if nextReloadTime.timeIntervalSince(date) < 5 * 60 {
            nextReloadTime.addTimeInterval(3600)
        }
        
        return nextReloadTime
    }
    
    
    func reloadActiveComplications() {
        let server = CLKComplicationServer.sharedInstance()
        
        for complication in server.activeComplications ?? [] {
            server.reloadTimeline(for: complication)
        }
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        DataGetter.shared.updateInfo(completion: {
            if let root = WKExtension.shared().rootInterfaceController as? InterfaceController {
                root.refreshUI()
            }
        })
        
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                NSLog("ExtensionDelegate: handling WKApplicationRefreshBackgroundTask")
                
                scheduleNextReload()
                
                DataGetter.shared.updateInfo(completion: {
                    self.reloadActiveComplications()
                    backgroundTask.setTaskCompletedWithSnapshot(false)
                })
                
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
}
