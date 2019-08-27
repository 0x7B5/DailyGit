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
    
    func getFormattedDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year = String(components.year!)
        var month = String(components.month!)
        var day = String(components.day!)
        
        if components.month! < 10 {
            month = "0" + String(components.month!)
        }
        
        if components.day! < 10 {
            day = "0" + String(components.month!)
        }
        
        let currentDate = "\(year)-\(month)-\(day)"
        
        print(currentDate)
        return currentDate
    }
    
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
                    print(jsonErr)
                    completion(false)
                }
            }.resume()
        }
        
    }
    
    func setupGithubUser(username: String, completion: @escaping (User?) -> ())  {
        //https://api.github.com/users/
        print("user user user")
        
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
                    print(jsonErr)
                    completion(nil)
                }
            }.resume()
        }
        
    }
    
    func setupContributions(startDay: String, username: String, completion: @escaping (ContributionList?) -> ())  {
        
//        var startingPoint = stringToDate(date: startDay)
//        #warning("Need to fix current date")
//        let endDate = Date() //we'll need to change this eventually
//
//        var contList = [Contribution]()
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        let calendar = Calendar.current
//
//
//        let datesBetweenArray = Date.dates(from: startingPoint, to: Date())
        
//        getGithubSource(username: username, completion: {
//            source, err in
//            if let pageSource = source {
//                for i in datesBetweenArray {
//
//                    let convertedDate = (formatter.string(from: i)).substring(to: 10)
//                    guard let doc: Document = try? SwiftSoup.parse(pageSource) else { return }
//                    guard let elements = try? doc.select("[class=day]") else { return }
//                    for i in elements {
//                        print(i)
//                    }
//
//                    self.getCommitsForDate(username: username, date: convertedDate, completion: {
//                        commitsCount in
//
//                        if commitsCount == nil {
//                            print("\(convertedDate) + nil :(")
//                        } else {
//                            print("\(convertedDate) + \(commitsCount)")
//                        }
//
//                        contList.append(Contribution(date: formatter.string(from: startingPoint), count: commitsCount ?? 0, color: "c6e48b", intensity: 1))
//                    })
//                }
//            }
//        })
        
        var contList = [Contribution]()
        getGithubSource(username: username, completion: {
            source, err in
            if let pageSource = source {
                guard let doc: Document = try? SwiftSoup.parse(pageSource) else { return
                    completion(nil) }
                guard let commitElements = try? doc.select("[class=day]") else { return
                    completion(nil) }
                
                for i in commitElements {
                    
                    let date = try? i.attr("data-date")
                    if date == nil {
                        continue
                    }
                    
                    let commitsCount = try? i.attr("data-count")
                    let fillColor = try? i.attr("fill")
                    
                    contList.append(Contribution(date: date!, count: Int(commitsCount ?? "0")!, color: fillColor ?? "ebedf0"))
                    print(contList.last)
                    
                }
            }
        })
        
        //print(contList)
        completion(ContributionList(contributions: contList))
        
    }
    
    func stringToDate(date: String) -> Date {
        print(date)
        #warning("somethig")
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:date)!
        
        return date
    }
    
    func getCommitsForDate(username: String, date: String, completion: @escaping (Int?) -> ()) {
        
        self.getGithubSource(username: username, completion: {
            source, err in
            if let pageSource = source {
                //print(pageSource)
                let leftSideString = """
                                  " data-count="
                                  """
                
                let rightSideString = """
                " data-date="\(date)"/>
                """
                
                
                guard
                    let rightSideRange = pageSource.range(of: rightSideString)
                    else {
                        print("couldn't find right range")
                        completion(nil)
                        return
                }
                
                let rangeOfTheData = pageSource.index(rightSideRange.lowerBound, offsetBy: -26)..<rightSideRange.lowerBound
                let subPageSource = pageSource[rangeOfTheData]
                // print(subPageSource)
                
                
                guard
                    let leftSideRange = subPageSource.range(of: leftSideString)
                    else {
                        print("couldn't find left range")
                        completion(nil)
                        return
                }
                
                let finalRange = leftSideRange.upperBound..<subPageSource.endIndex
                let commitsValueString = subPageSource[finalRange]
                
                // print(commitsValueString)
                if let commitsValueInt = Int(commitsValueString) {
                    completion(commitsValueInt)
                } else {
                    completion(nil)
                }
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
                
                print("JSON ")
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(user) {
                    print("setting")
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "CurrentUser")
                    defaults.synchronize()
                    completion()
                }
                
            })
        }
    }
    
}
