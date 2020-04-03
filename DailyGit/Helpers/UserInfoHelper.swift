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
    case user, name, username, bio, photoUrl, contributions, yearCreated, dateCreated, currentWeek, today, yesterday, longestStreak, currentStreak
}

public class UserInfoHelper {
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
                }
            }
        }
        return ""
    }
    
    func getDailyCommits(completion: @escaping () -> ())  {
        GithubDataManager.shared.updateInfo(completion: {
            let date = DateHelper.shared.getFormattedDate()
            if let currentContributions = self.readInfo(info: .contributions) as? ContributionList {
                for i in currentContributions.contributions {
                    if i.date == date {
                        self.defaults.set(i.count, forKey: "DailyCommits")
                        self.defaults.synchronize()
                        completion()
                    }
                }
            }
            completion()
        })
    }
    
    func getCurrentStreak() {
        if let currentContributions = self.readInfo(info: .contributions) as? ContributionList {
            var date = DateHelper.shared.getFormattedDate()
            
            if currentContributions.contributions.last!.count == 0 {
                date = DateHelper.shared.getYesterdayDate()
            }
            
            
            var counter = 0
            var countingYet = false
            
            for i in currentContributions.contributions.reversed() {
                if countingYet {
                    if i.count > 0 {
                        counter += 1
                    } else {
                        break
                    }
                }
                
                if i.date == date {
                    countingYet = true
                    if i.count > 0 {
                        counter += 1
                    }
                }
                
            }
            
            self.defaults.set(counter, forKey: "CurrentStreak")
            self.defaults.synchronize()
            print("CURRENT STREAK: \(counter)")
        }
    }
    
    #warning("Only have to run this again if currentStreak is longer than longestStreak, shouldn't have to run this everytime we refresh")
    func getLongestStreak() {
        if let currentContributions = readInfo(info: .contributions) as? ContributionList {
            var counter = 0
            var maxStreaks = 0
            
            for i in currentContributions.contributions {
                if i.count > 0 {
                    counter += 1
                } else {
                    if counter > maxStreaks {
                        maxStreaks = counter
                    }
                    counter = 0
                }
            }
            self.defaults.set(maxStreaks, forKey: "LongestStreak")
            self.defaults.synchronize()
            print("Longest Streak: ", maxStreaks)
        }
    }
    
    func refreshEverything(completion: @escaping () -> ()) {
        
        getDailyCommits {
            self.getCurrentStreak()
            self.getLongestStreak()
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
                print(DateHelper.shared.getYear(myDate: i.date, isIso: true))
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
