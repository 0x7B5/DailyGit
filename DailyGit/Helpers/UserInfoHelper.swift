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
    case user, name, username, bio, photoUrl, contributions, yearCreated, dateCreated, currentWeek, lastWeek, today, yesterday, longestStreak, currentStreak, updateTime, userUpdateTime
}

enum refreshState {
    case alreadyRefreshing, goodToRefresh
}

public class UserInfoHelper {
    var currentState: refreshState = .goodToRefresh
    static let shared = UserInfoHelper()
    let defaults = UserDefaults.standard
    
    func readInfo(info: Userinfo) -> Any? {
        if let savedPerson = defaults.object(forKey: "CurrentUser") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                switch info {
                case .user:
                    return loadedPerson
                case .name:
                    return loadedPerson.name
                case .username:
                    return loadedPerson.username
                case .bio:
                    return loadedPerson.bio
                case .photoUrl:
                    return loadedPerson.photoUrl
                case .contributions:
                    return loadedPerson.contributions
                case .yearCreated:
                    return loadedPerson.yearCreated
                case .dateCreated:
                    return loadedPerson.dateCreated
                case .currentWeek:
                    return loadedPerson.currentWeek
                case .lastWeek:
                    return loadedPerson.lastWeek
                case .today:
                    if let today = loadedPerson.contributions.contributions.last {
                        return today
                    }
                    return nil
                case .yesterday:
                    let count = loadedPerson.contributions.contributions.count
                    if count > 3 {
                        return loadedPerson.contributions.contributions[count-2]
                    }
                    return nil
                case .longestStreak:
                    return loadedPerson.longestStreak
                case .currentStreak:
                    return loadedPerson.currentStreak
                case .updateTime:
                    return loadedPerson.updateTime
                case .userUpdateTime:
                    return loadedPerson.userUpdateTime
                }
            }
        }
        return ""
    }
    
    
    func refreshEverything(completion: @escaping () -> ()) {
        if Reachability.shared.isConnectedToNetwork() {
            if currentState == .goodToRefresh {
                currentState = .alreadyRefreshing
                GithubDataManager.shared.updateInfo(completion: {
                    self.currentState = .goodToRefresh
                    completion()
                })
            }
        } else {
            currentState = .goodToRefresh
            completion()
        }
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
        return "#196127".getColor()
    }
    
    
}
