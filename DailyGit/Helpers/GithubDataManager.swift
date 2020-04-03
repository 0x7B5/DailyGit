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
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var blankCount = 0
    var errorMessage = ""
    typealias QueryResult = ([User]?, String) -> Void
    
    private init() { }
    
    let defaults = UserDefaults.standard
    
    
    #warning("Fix this")
    
    func isGithubUser(username: String, completion: @escaping (Bool) -> ()) {
        if let url = URL(string: "https://api.github.com/users/\(username)") {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if err != nil {
                    print(err ?? "Error")
                    completion(false)
                }
                guard let data = data else { return }
                
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
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
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    func setupGithubUser(username: String, completion: @escaping (User?) -> ())  {
        //https://api.github.com/users/
        if let url = URL(string: "https://api.github.com/users/\(username)") {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                //also perhaps check response status 200 OK
                if err != nil {
                    print(err ?? "Error")
                    completion(nil)
                }
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
                        
                        var bio = ""
                        var name = ""
                        
                        if let temp = json["bio"] as? String {
                            bio = temp
                        }
                        
                        //let name = json["name"] as? String,
                        if let myUsername = json["login"] as? String, let photourl = json["avatar_url"] as? String, let creationDate = json["created_at"] as? String{
                            print("Set up username")
                            self.getData(from: URL(string: photourl)!) { data, response, error in
                                guard let data = data, error == nil else { return }
                                print("Download Finished")
                                
                                let myImage = UIImage(data: data)!
                                
                                self.saveImage(imageName: "ProfilePic", image: myImage)
                                print("finished image")
                                
                                if let tempName = json["name"] as? String {
                                    name = tempName
                                } else {
                                    name = myUsername
                                }
                                
                                let creationYear = Int(DateHelper.shared.stringToYear(myDate: creationDate, IsoFormat: true))!
                                #warning("Fix setup contributions")
                                self.getAllContributions(startYear: creationYear, username: myUsername, completion: {
                                    contributions in
                                    if contributions != nil {
                                        let user = User(name: name, username: myUsername, bio: bio, photoUrl: photourl,dateCreated: creationDate, yearCreated: creationYear ,contributions: contributions!, currentWeek: self.setupCurrentWeek(contributions!))
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
    
    func setupCurrentWeek(_ currentList: ContributionList) -> ContributionList {
        var randContList = [Contribution?](repeating: nil, count: 6)
        for element in currentList.contributions.reversed() {
            randContList.insert(element, at: element.dayOfWeek)
            if(element.dayOfWeek == 0) {
                break
            }
        }
        return ContributionList(contributions: randContList.compactMap { $0 })
    }
    
    
    func getAllContributions(startYear: Int, username: String, completion: @escaping (ContributionList?) -> ())  {
        //let myGroup = DispatchGroup()
        print(DateHelper.shared.getFormattedDate())
        if let url = URL(string: "https://vlad-munteanu.appspot.com/contributions/\(username)/\(startYear)/\(DateHelper.shared.getFormattedDate())") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let userList = try? JSONDecoder().decode(ContributionList.self, from: data)
                    completion(userList)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
    
    
    func getDailyCommits(username: String, completion: @escaping (Contribution?) -> ()) {
        if let url = URL(string: "https://vlad-munteanu.appspot.com/dayCount/\(username)/\(DateHelper.shared.getFormattedDate())") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error ?? "Error")
                    completion(nil)
                }
                if let data = data {
                    let contribution = try! JSONDecoder().decode(Contribution.self, from: data)
                    completion(contribution)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
    
    func getMonthlyCommits(username: String, completion: @escaping (ContributionList?) -> ()) {
        if let url = URL(string: "https://vlad-munteanu.appspot.com/monthlyCount/\(username)/\(DateHelper.shared.getFormattedDate())") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error ?? "")
                    completion(nil)
                }
                
                if let data = data {
                    let userList = try! JSONDecoder().decode(ContributionList.self, from: data)
                    completion(userList)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
    
    func getWeeklyCommits(username: String, completion: @escaping (ContributionList?) -> ()) {
        if let url = URL(string: "https://vlad-munteanu.appspot.com/weeklyCount/\(username)/\(DateHelper.shared.getFormattedDate())") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error ?? "")
                    completion(nil)
                }
                
                if let data = data {
                    let userList = try! JSONDecoder().decode(ContributionList.self, from: data)
                    completion(userList)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
    
    func refreshUserInfo(completion: @escaping () -> ()) {
        if let url = URL(string: "https://api.github.com/users/\(UserInfoHelper.shared.readInfo(info: .username))") {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if err != nil {
                    print(err ?? "")
                    completion()
                }
                
                guard let data = data else { return }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if (json["message"] as? String == "Not Found") {
                            completion()
                        }
                        
                        if (json["avatar-url"] as? String == "Not Found") {
                            completion()
                        }
                        
                        var bio = ""
                        var name = ""
                        
                        if let temp = json["bio"] as? String {
                            bio = temp
                        }
                        
                        //let name = json["name"] as? String,
                        if let myUsername = json["login"] as? String, let photourl = json["avatar_url"] as? String, let creationDate = json["created_at"] as? String{
                            
                            var photoChanged = false
                            
                            if var savedPerson = self.defaults.object(forKey: "CurrentUser") as? User {
                                // Should probably use setters and getters here but quick fix
                                savedPerson.name = name
                                savedPerson.username = myUsername
                                savedPerson.bio = bio
                                
                                if (photourl != savedPerson.photoUrl) {
                                    savedPerson.photoUrl = photourl
                                    photoChanged = true
                                }
                                
                                savedPerson.dateCreated = creationDate
                                UserInfoHelper.shared.updateUserInDefaults(userToEncode: savedPerson)
                                
                                
                            } else {
                                completion()
                            }
                            
                            if photoChanged {
                                self.getData(from: URL(string: photourl)!) { data, response, error in
                                    guard let data = data, error == nil else { return }
                                    print("Download Finished")
                                    
                                    let myImage = UIImage(data: data)!
                                    
                                    self.saveImage(imageName: "ProfilePic", image: myImage)
                                    print("finished image")
                                    
                                    if let tempName = json["name"] as? String {
                                        name = tempName
                                    } else {
                                        name = myUsername
                                    }
                                }
                            }
                        }
                    }
                } catch _ {
                    completion()
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
            #warning("We could probably run these functions asyncrously instead but idk")
            refreshUserInfo(completion: {
                self.getAllContributions(startYear: UserInfoHelper.shared.readInfo(info: .yearCreated) as! Int, username: UserInfoHelper.shared.readInfo(info: .username) as! String, completion: {
                    contributions in
                    print("We here here")
                    //print(contributions)
                    #warning("This is giving us a lot of crashes idk why")
                    print(contributions!.contributions.last ?? " ")
                    
                    var savedPerson = UserInfoHelper.shared.readInfo(info: .user) as! User
                    // Should probably use setters and getters here but quick fix
                    if let myContributions = contributions {
                        savedPerson.contributions = myContributions
                        print("saved person updarted")
                    } else {
                        completion()
                    }
                    
                    
                    UserInfoHelper.shared.updateUserInDefaults(userToEncode: savedPerson)
                    completion()
                })
            })
            
        } else {
            completion()
        }
    }
    
}




