//
//  CommitGetter.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/10/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation

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
                        if let myUsername = json["login"] as? String, let photourl = json["avatar_url"] as? String {
                            
                            if let tempName = json["name"] as? String {
                                name = tempName
                            } else {
                                name = myUsername
                            }
                            
                            self.setupContributions(username: myUsername, completion: {
                                contributions, err in
                                if contributions != nil {
                                    let user = User(name: name, username: myUsername, bio: bio, photoUrl: photourl, contributions: contributions!)
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
    
    func setupContributions(username: String, completion: @escaping (ContributionList?, Error?) -> ())  {
//        let startingPoint = Date()
//        //https://api.github.com/users/
//        if let url = URL(string: "https://github-contributions-api.now.sh/v1/\(username)") {
//            URLSession.shared.dataTask(with: url) { (data, response, err) in
//                //perhaps check err
//                //also perhaps check response status 200 OK
//                guard let data = data else { return }
//
//                do {
//                    let contributions = try JSONDecoder().decode(ContributionList.self, from: data)
//                    completion(contributions, nil)
//                    print("\(startingPoint.timeIntervalSinceNow * -1) seconds elapsed")
//                    //print(user)
//                } catch let err {
//                    completion(nil, err)
//                    print(err)
//                }
//
//            }.resume()
//        }
    }
    
    
    
    func getDailyCommits(username: String, completion: () -> ()) -> Int {
        
        let pageSource = getGithubSource(username: username, completion: nil)
        //print(pageSource)
        let leftSideString = """
        " data-count="
        """
        
        let rightSideString = """
        " data-date="\(getFormattedDate())"/>
        """
        
        
        guard
            let rightSideRange = pageSource.range(of: rightSideString)
            else {
                print("couldn't find right range")
                completion()
                return 0
        }
        
        let rangeOfTheData = pageSource.index(rightSideRange.lowerBound, offsetBy: -26)..<rightSideRange.lowerBound
        let subPageSource = pageSource[rangeOfTheData]
       // print(subPageSource)
        
        
        guard
            let leftSideRange = subPageSource.range(of: leftSideString)
            else {
                print("couldn't find left range")
                completion()
                return 0
        }
        
        let finalRange = leftSideRange.upperBound..<subPageSource.endIndex
        let commitsValueString = subPageSource[finalRange]
        
       // print(commitsValueString)
        
        let commitsValueInt = Int(commitsValueString) ?? 0
        
        UserDefaults.standard.set(commitsValueInt, forKey: "dailyCommits")
        
        completion()
        return commitsValueInt
    }
    
    func getGithubSource(username: String, completion: (() -> ())?) -> String {
        
        //https://github-contributions-api.now.sh/v1/vlad-munteanu
        if var urlComponents = URLComponents(string: "https://github-contributions-api.now.sh/v1/") {
            urlComponents.query = "\(username)"
            
            guard let url = urlComponents.url else {
                return ""
            }
            
        }
        
        let baseUrl = "https://github.com/"
        let url = URL(string: baseUrl + username)!
        var globalHTMLString = ""
        let semaphore = DispatchSemaphore(value: 0)
        
        //starts paused
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("data was nil")
                return
            }
            guard let htmlString = String(data: data, encoding: .utf8) else {
                print("couldn't cast data into String")
                return
            }
            
            globalHTMLString = htmlString
            //print("global: \(globalHTMLString)")
            semaphore.signal()
        }
        //this starts the task
        //all tasks start in suspended state
        task.resume()
        semaphore.wait()
        return globalHTMLString
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
