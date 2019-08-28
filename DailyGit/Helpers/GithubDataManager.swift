//
//  CommitGetter.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/10/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation
import SwiftSoup

public class GithubDataManager {
    static let shared = GithubDataManager()
    
    typealias JSONDictionary = [String: Any]
    
    private init() { }
    
    func isGithubUser(username: String, completion: @escaping (Bool) -> ()) {
        if let url = URL(string: "https://api.github.com/users/\(username)") {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                //also perhaps check response status 200 OK
                guard let data = data else { return }
                
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // try to read out a string array
                        // Is this a valid githubUsername?
                        if (json["message"] as? String == "Not Found") {
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } catch let jsonErr {
                    completion(false)
                }
            }.resume()
        }
        
    }
    
    func setupGithubUser(username: String, completion: @escaping (User?) -> ())  {
        //https://api.github.com/users/
        
        if let url = URL(string: "https://api.github.com/users/\(username)") {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                //also perhaps check response status 200 OK
                
                guard let data = data else { return }
                
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // try to read out a string array
                        // Is this a valid githubUsername?
                        if (json["message"] as? String == "Not Found") {
                            completion(nil)
                        }
                        
                        var bio = ""
                        var name = ""
                        
                        if let temp = json["bio"] as? String {
                            bio = temp
                        }
                        
                        
                        //let name = json["name"] as? String,
                        if let myUsername = json["login"] as? String, let photourl = json["avatar_url"] as? String, let creationDate = json["created_at"] as? String{
                            
                            if let tempName = json["name"] as? String {
                                name = tempName
                            } else {
                                name = myUsername
                            }
                            
                            #warning("Fix setup contributions")
                            self.setupContributions(startDay: creationDate, username: myUsername, completion: {
                                contributions in
                                if contributions != nil {
                                    let user = User(name: name, username: myUsername, bio: bio, photoUrl: photourl,dateCreated: creationDate, contributions: contributions!)
                                    print(user)
                                    completion(user)
                                } else {
                                    completion(nil)
                                }
                            })
                        }
                    }
                } catch let jsonErr {
                    completion(nil)
                }
            }.resume()
        }
        
    }
    
    #warning("html parsing only shows commits from past year")
    
    func setupContributions(startDay: String, username: String, completion: @escaping (ContributionList?) -> ())  {
        var year = DateHelper.shared.getYear(myDate: startDay)
        var currentYear = DateHelper.shared.getYear(myDate: Date())
        
        var contList = [Contribution]()
        getGithubSource(username: username, completion: {
            source, err in
            if let pageSource = source {
                guard let doc: Document = try? SwiftSoup.parse(pageSource) else { return
                    completion(nil) }
                guard let commitElements = try? doc.select("[class=day]") else { return
                    completion(nil) }
                
                var counter = 0
                var weeksCount =  0
                for i in commitElements {
                    
                    if weeksCount%7 == 0 {
                        counter += 1
                    }
                    
                    let date = try? i.attr("data-date")
                    if date == nil {
                        continue
                    }
                    
                    let commitsCount = try? i.attr("data-count")
                    let fillColor = try? i.attr("fill")
                    
                    let aContribution: Contribution = (Contribution(date: date!, count: Int(commitsCount ?? "0")!, color: fillColor ?? "ebedf0"))
                    
                    contList.append(aContribution)
                    weeksCount += 1
                }
                print("weeksCount \(weeksCount)")
                completion(ContributionList(contributions: contList))
            }
        })
        
    }
    
    func getGithubSource(username: String, completion: @escaping (String?, Error?) -> ()) {
        if let url = URL(string: "https://github.com/\(username)") {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                guard let data = data else {
                    completion(nil, err)
                    return
                }
                // This has to throw an error
                do {
                    guard let htmlString = String(data: data, encoding: .utf8) else {
                        print("couldn't cast data into String")
                        completion(nil, err)
                        return
                    }
                    completion(htmlString, nil)
                } catch let err {
                    completion(nil, err)
                }
            }.resume()
        }
        
    }
    
    func getGithubCommits(username: String, completion: (() -> ())?) -> String {
        
        return ""
    }
    
    func updateInfo(completion: @escaping () -> ()) {
        if(UserDefaults.standard.object(forKey: "CurrentUser") != nil) {
            setupGithubUser(username: ReadUserInfoHelper.shared.readInfo(info: .username) as! String, completion: {
                user in
                
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(user) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "CurrentUser")
                    defaults.synchronize()
                    completion()
                }
                
            })
        }
    }
    
}
