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
    
    func isValidUser(username: String, completion: () -> ()) -> Bool {
        let pageSource = getGithubSource(username: username, completion: nil)
        //print(pageSource)
        let notFoundError = "Not Found"
        
        if pageSource.contains(notFoundError) {
            completion()
            return false
        }
        completion()
        return true
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
}
