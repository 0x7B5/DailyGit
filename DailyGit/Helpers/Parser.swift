//
//  Parser.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 12/14/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation

class Parser {
    func dataToUser(userData: Data, contributionData: String) -> User? {
        
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: userData, options: []) as? [String: Any] {
                // try to read out a string array
                // Is this a valid githubUsername?
                if (json["message"] as? String == "Not Found") {
                    return nil
                }
                
                if (json["avatar-url"] as? String == "Not Found") {
                    return nil
                }
                
                let avatar_url = json["avatar-url"] as? String
                
                
                
                var bio = ""
                var name = ""
                
                if let temp = json["bio"] as? String {
                    bio = temp
                }
                
                
                //let name = json["name"] as? String,
                if let myUsername = json["login"] as? String, let photourl = json["avatar_url"] as? String, let creationDate = json["created_at"] as? String {
                    if let tempName = json["name"] as? String {
                        name = tempName
                    } else {
                        name = myUsername
                    }
                    return user 
                }
                
            }
        } catch _ {
            return nil
        }
    }
    
}
