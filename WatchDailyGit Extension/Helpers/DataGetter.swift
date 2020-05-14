//
//  DataGetter.swift
//  WatchDailyGit Extension
//
//  Created by Vlad Munteanu on 5/13/20.
//  Copyright © 2020 Vlad Munteanu. All rights reserved.
//

import Foundation

enum DataInfo {
    case username, commitsToday, commitsYesterday, currentStreak
}

public class DataGetter {
    static let shared = DataGetter()
    let defaults = UserDefaults.standard
    
    func readInfo(info: DataInfo) -> Any? {
        if let savedData = defaults.object(forKey: "CurrentData") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(GenericData.self, from: savedData) {
                switch info {
                case .username:
                    return loadedData.username
                case .commitsToday:
                    return loadedData.commitsToday
                case .commitsYesterday:
                    return loadedData.commitsYesterday
                case .currentStreak:
                    return loadedData.currentStreak
                }
            }
        }
        return ""
        
    }
    
    
    func updateUserInDefaults(dataToEncode: GenericData) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(dataToEncode) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "CurrentData")
            defaults.synchronize()
            print("Data encoded and synced")
            print("")
        }
    }
    
    func isThereData() -> Bool {
        return (DataGetter.shared.readInfo(info: .username) as? String != "")
    }
    
    
}
