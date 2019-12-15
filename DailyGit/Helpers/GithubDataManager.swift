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
    
    private lazy var bgSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: Constants.sessionID)
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config)
    }()
    
    typealias JSONDictionary = [String: Any]
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var blankCount = 0
    var errorMessage = ""
    typealias QueryResult = ([User]?, String) -> Void
    
    private init() { }
    
    #warning("Fix this")
    
    func isGithubUser(username: String, completion: @escaping (Bool) -> ()) {
        if let url = URL(string: "https://api.github.com/users/\(username)") {
            bgSession.dataTask(with: url) { (data, response, err) in
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
                } catch _ {
                    completion(false)
                }
            }.resume()
        }
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        bgSession.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    func setupGithubUser(username: String, completion: @escaping (User?) -> ())  {
        //https://api.github.com/users/
        if let url = URL(string: "https://api.github.com/users/\(username)") {
            bgSession.dataTask(with: url) { (data, response, err) in
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
                        
                        if (json["avatar-url"] as? String == "Not Found") {
                            completion(nil)
                        }
                        
                        let avatar_url = json["avatar-url"] as? String
                        
                        
                        
                        var bio = ""
                        var name = ""
                        
                        if let temp = json["bio"] as? String {
                            bio = temp
                        }
                        
                        
                        //let name = json["name"] as? String,
                        if let myUsername = json["login"] as? String, let photourl = json["avatar_url"] as? String, let creationDate = json["created_at"] as? String{
                            
                            self.getData(from: URL(string: photourl)!) { data, response, error in
                                guard let data = data, error == nil else { return }
                                print("Download Finished")
                                
                                
                                
                                let myImage = UIImage(data: data)!.roundImage()
                                
                                self.saveImage(imageName: "ProfilePic", image: myImage)
                                
                                
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
                                        print("Done it again \(user)")
                                        completion(user)
                                    } else {
                                        completion(nil)
                                    }
                                })
                            }
                        }
                        
                    }
                } catch _ {
                    completion(nil)
                }
            }.resume()
        }
        
    }
    
    #warning("html parsing only shows commits from past year")
    
    func setupContributions(startDay: String, username: String, completion: @escaping (ContributionList?) -> ())  {
        let year = DateHelper.shared.getYear(myDate: startDay, isIso: true)
        let currentYear = DateHelper.shared.getYear(myDate: DateHelper.shared.getFormattedDate(), isIso: false)
        
        var contList = [Contribution]()
        let myGroup = DispatchGroup()
        
        for i in year...currentYear {
            myGroup.enter()
            getGithubSourceForYear(username: username, year: i, completion: {
                source in
                if let pageSource = source {
                    guard let doc: Document = try? SwiftSoup.parse(pageSource) else { return
                    }
                    guard let commitElements = try? doc.select("[class=day]") else { return
                    }
                    
                    for i in commitElements {
                        let date = try? i.attr("data-date")
                        if date == nil {
                            continue
                        }
                        
                        
                        
                        let commitsCount = try? i.attr("data-count")
                        let fillColor = try? i.attr("fill")
                        
                  
                        
                        let currentDay = DateHelper.shared.getDayOfWeek(fromDate:  DateHelper.shared.stringToDate(myDate: date!, IsoFormat: false))
                        
                        
                        let aContribution: Contribution = (Contribution(date: date!, count: Int(commitsCount ?? "0")!, color: fillColor ?? "ebedf0", dayOfWeek: currentDay ?? 0))
                        
                        contList.append(aContribution)
                    }
                }
                myGroup.leave()
            })
            
            
            myGroup.notify(queue: .main) {
                completion(ContributionList(contributions: contList))
            }
            
            
        }
        
        
    }
    
    func getGithubSourceForYear(username: String, year: Int, completion: @escaping (String?) -> ()) {
        if let url = URL(string: "https://github.com/\(username)?tab=overview&from=\(year)-12-01&to=\(year)-12-31") {
            bgSession.dataTask(with: url) { (data, response, err) in
                guard let data = data else {
                    completion(nil)
                    return
                }
                // This has to throw an error
                do {
                    guard let htmlString = String(data: data, encoding: .utf8) else {
                        print("couldn't cast data into String")
                        completion(nil)
                        return
                    }
                    completion(htmlString)
                } catch let err {
                    completion(nil)
                }
            }.resume()
        }
    }
    
    func getGithubSource(username: String, completion: @escaping (String?, Error?) -> ()) {
        if let url = URL(string: "https://github.com/\(username)") {
            bgSession.dataTask(with: url) { (data, response, err) in
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
                } catch  {
                    completion(nil, err)
                }
            }.resume()
        }
        
    }
    
    func saveImage(imageName: String, image: UIImage) {
        
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        
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


