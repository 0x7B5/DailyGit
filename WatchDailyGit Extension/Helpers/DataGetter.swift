//
//  DataGetter.swift
//  WatchDailyGit Extension
//
//  Created by Vlad Munteanu on 5/13/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation

enum DataInfo {
    case allData, username, commitsToday, commitsYesterday, currentStreak, creationYear
}

public class DataGetter {
    static let shared = DataGetter()
    let defaults = UserDefaults.standard
    
    static let dateFormatter: DateFormatter = {
        let d = DateFormatter()
        
        // not sure if this is needed, but just to be safe
        // see https://developer.apple.com/library/archive/qa/qa1480/
        d.locale = Locale(identifier: "en_US_POSIX")
        
        d.dateFormat = "dd.MM.yyyy"
        
        // make sure we use CET timezone - if you're e.g. in Moscow
        // and you ask for '19.02.2019' on 19 Feb after midnight
        // (still 18 Feb in Poland), you'll get no data
        d.timeZone = TimeZone(identifier: "Europe/Warsaw")!
        
        return d
    }()
    
    func readInfo(info: DataInfo) -> Any? {
        if let savedData = defaults.object(forKey: "CurrentData") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(GenericData.self, from: savedData) {
                switch info {
                case .allData:
                    return loadedData
                case .username:
                    return loadedData.username
                case .commitsToday:
                    return loadedData.commitsToday
                case .commitsYesterday:
                    return loadedData.commitsYesterday
                case .currentStreak:
                    return loadedData.currentStreak
                case .creationYear:
                    return loadedData.creationYear
                }
            }
        }
        return ""
        
    }
    func getWeeklyCommits(username: String, creationYear: String, completion: @escaping (GenericData?) -> ()) {
        if let url = URL(string: "https://vlad-munteanu.appspot.com/aw/\(username)/\(creationYear)/\(DataGetter.shared.getFormattedDate())") {
            print(url)
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error ?? "")
                    completion(nil)
                }
                
                guard let data = data else { return }
                
                do {
                    if var json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        json = json["data"] as! [String : Any]
                        if let username = json["username"] as? String, let commitsToday = json["commitsToday"] as? Int, let commitsYesterday = json["commitsYesterday"] as? Int, let creationYear = json["creationYear"] as? String, let currentStreak = json["currentStreak"] as? Int {
                            let newUser = GenericData(username: username, commitsToday: commitsToday, commitsYesterday: commitsYesterday, currentStreak: currentStreak, creationYear: Int(creationYear) ?? 2018)
                            print(newUser)
                            completion(newUser)
                        } else {
                            print(json)
                            completion(nil)
                        }
                    } else {
                        completion(nil)
                    }
                } catch _ {
                    completion(nil)
                }
            }.resume()
        }
    }
    
    func getFormattedDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        
        return result
    }
    
    func updateInfo(completion: @escaping () -> ()) {
        if isThereData() {
            if let username = DataGetter.shared.readInfo(info: .username) as? String, let creationYear = DataGetter.shared.readInfo(info: .creationYear) as? Int {
                getWeeklyCommits(username: username, creationYear: String(creationYear), completion: {
                    myData in
                    if myData != nil {
                        DataGetter.shared.updateUserInDefaults(dataToEncode: myData!)
                        completion()
                    } else {
                        completion()
                    }
                    
                })
                
            } else {
                completion()
            }
        } else {
            completion()
        }
    }
    
    
    func updateUserInDefaults(dataToEncode: GenericData) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(dataToEncode) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "CurrentData")
            defaults.synchronize()
            print(dataToEncode)
            print("Data encoded and synced")
            print("")
        }
    }
    
    func isThereData() -> Bool {
        return (DataGetter.shared.readInfo(info: .username) as? String != "")
    }
    
    
}
