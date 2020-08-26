//
//  UserInfoHelper.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/19/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit

enum Userinfo {
    case user, name, username, bio, photoUrl, contributions, yearCreated, dateCreated, currentWeek, lastWeek, today, yesterday, longestStreak, currentStreak, updateTime, userUpdateTime, currentMonth, lastMonth
}

enum refreshState {
    case alreadyRefreshing, goodToRefresh
}

enum NotificationInfo {
    case full, enabled, date, times
}

public class UserInfoHelper {
    var currentState: refreshState = .goodToRefresh
    static let shared = UserInfoHelper()
    let defaults = UserDefaults.standard
    
    func readInfo(info: Userinfo) -> Any? {
        let start = NSDate()
        if let savedPerson = defaults.object(forKey: "CurrentUser") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                switch info {
                case .user:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson
                case .name:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.name
                case .username:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.username
                case .bio:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.bio
                case .photoUrl:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.photoUrl
                case .contributions:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.contributions
                case .yearCreated:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.yearCreated
                case .dateCreated:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.dateCreated
                case .currentWeek:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.currentWeek
                case .lastWeek:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.lastWeek
                case .today:
                    if let today = loadedPerson.contributions.contributions.last {
                        let elapsed = start.timeIntervalSinceNow
                        print("It took \(elapsed)")
                        return today
                    }
                    return nil
                case .yesterday:
                    let count = loadedPerson.contributions.contributions.count
                    if count > 3 {
                        let elapsed = start.timeIntervalSinceNow
                        print("It took \(elapsed)")
                        return loadedPerson.contributions.contributions[count-2]
                    }
                    return nil
                case .longestStreak:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.longestStreak
                case .currentStreak:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.currentStreak
                case .updateTime:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.updateTime
                case .userUpdateTime:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.userUpdateTime
                case .currentMonth:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.currentMonth
                case .lastMonth:
                    let elapsed = start.timeIntervalSinceNow
                    print("It took \(elapsed)")
                    return loadedPerson.lastMonth
                }
            }
        }
        return ""
    }
    
    
    func refreshEverything(completion: @escaping () -> ()) {
        #if os(watchOS)
        if currentState == .goodToRefresh {
            currentState = .alreadyRefreshing
            GithubDataManager.shared.updateInfo(completion: {
                self.currentState = .goodToRefresh
                completion()
            })
        } else {
            currentState = .goodToRefresh
            completion()
        }
        #else
        if Reachability.shared.isConnectedToNetwork() {
            //            if currentState == .goodToRefresh {
            //                currentState = .alreadyRefreshing
            //                GithubDataManager.shared.updateInfo(completion: {
            //                    self.currentState = .goodToRefresh
            //                    completion()
            //                })
            //            }
            currentState = .alreadyRefreshing
            GithubDataManager.shared.updateInfo(completion: {
                self.currentState = .goodToRefresh
                completion()
            })
        } else {
            currentState = .goodToRefresh
            completion()
        }
        #endif
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func getYearlyContributionsDates() -> Int{
        var yearCount = 0
        
        if let currentContributions = readInfo(info: .contributions) as? ContributionList {
            for i in currentContributions.contributions {
                if (DateHelper.shared.getYear(myDate: i.date, isIso: true) == 2019) {
                    if i.count > 0 {
                        yearCount += 1
                    }
                }
            }
        }
        return yearCount
    }
    
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        
        return nil
    }
    
    
    func updateUserInDefaults(userToEncode: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userToEncode) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "CurrentUser")
            defaults.synchronize()
            print("User encoded and synced")
            print("")
        }
    }
    
    func readNotificationData(info: NotificationInfo) -> Any? {
        
        if let savedStatus = defaults.object(forKey: "NotificationStatus") as? Data {
            let decoder = JSONDecoder()
            if let status = try? decoder.decode(NotificationStatus.self, from: savedStatus) {
                switch info {
                case .full:
                    return status
                case .enabled:
                    return status.notificationsEnabled
                case .date:
                    return status.date
                case .times:
                    return status.times
                }
            }
        }
        return NotificationStatus(notificationsEnabled: nil, date: nil, times: nil)
    }
    
    func setNotificationStatus(status: NotificationStatus) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(status) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "NotificationStatus")
            defaults.synchronize()
        }
        
    }
    
    
    func canIAskAgain(date: Date, times: Int) -> Bool {
        
        if times > 3 {
            return false
        }
        
        let diffInDays = Calendar.current.dateComponents([.day], from: date, to: Date()).day
        
        if let diff = diffInDays {
            if diff > 30 {
                return true
            }
        }
        
        return false
        
    }
    
    
    func getStreakColor(commits: Int) -> UIColor {
        if commits == 0 {
            return "#ebedf0".getColor()
        } else if commits <= 10 {
            return "#c6e48b".getColor()
        } else if commits <= 50 {
            return "#7bc96f".getColor()
        } else if commits <= 100 {
            return "#239a3b".getColor()
        }
        return "#ebedf0".getColor()
    }
    
    
}
