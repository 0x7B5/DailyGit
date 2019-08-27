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
                //print(loadedPerson.name)

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
    
    func getDailyCommits(completion: @escaping (Int) -> ())  {
        GithubDataManager.shared.updateInfo(completion: {
            //have to re-pull data from github
            let date = GithubDataManager.shared.getFormattedDate()
            let currentContributions = self.readInfo(info: .contributions) as? ContributionList
            
            for i in currentContributions!.contributions {
                if i.date == date {
                    completion(i.count)
                    print(i)
                }
            }
        })
    }
    
    
    
}
