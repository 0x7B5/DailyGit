//
//  ReadUserInfoHelper.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/19/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation

enum Userinfo {
    case  name, username, bio, photoUrl, contributions, dateCreated
}

public class ReadUserInfoHelper {
    static let shared = ReadUserInfoHelper()
    let defaults = UserDefaults.standard
    
    func readInfo(info: Userinfo) -> Any {
        if let savedPerson = defaults.object(forKey: "CurrentUser") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                switch info {
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
                case .dateCreated:
                    return loadedPerson.dateCreated
                }
            }
        }
        return ""
    }
    
    func getDailyCommits(completion: @escaping () -> ())  {
        GithubDataManager.shared.updateInfo(completion: {
            //have to re-pull data from github
            let date = DateHelper.shared.getFormattedDate()
            let currentContributions = self.readInfo(info: .contributions) as? ContributionList
            
            
            for i in currentContributions!.contributions {
                if i.date == date {
                    self.defaults.set(i.count, forKey: "DailyCommits")
                    self.defaults.synchronize()
                    completion()
                    //print(i)
                }
            }
        })
    }
    
    func getCurrentStreak() {
        let currentContributions = readInfo(info: .contributions) as? ContributionList
        let date = DateHelper.shared.getFormattedDate()
        
        var counter = 0
        var countingYet = false
        
        for i in currentContributions!.contributions.reversed() {
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
    
    func getLongestStreak() {
        let currentContributions = readInfo(info: .contributions) as? ContributionList
        
        var counter = 0
        var maxStreaks = 0
        
        for i in currentContributions!.contributions {
                if i.count > 0 {
                    counter += 1
                } else {
                    if counter > maxStreaks {
                        maxStreaks = counter
                    }
                    counter = 0
                    //print("---------------------------")
                }
        }
        self.defaults.set(maxStreaks, forKey: "LongestStreak")
        self.defaults.synchronize()
        print("Longest Streak: ", maxStreaks)
    }
    
    func refreshEverything() {
        getDailyCommits {
            self.getCurrentStreak()
            self.getLongestStreak()
        }
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    
    
    
    
}
