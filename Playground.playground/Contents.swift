import UIKit
import SwiftSoup

var str = "Hello, playground"

func setupContributions(startDay: String, username: String, completion: () -> ()) {
   
    
    var year = getYear(myDate: startDay)
    
    var currentYear = getYear(myDate: dateToString(date: Date()))
    
    //user created account this year
    if year == currentYear {
        getGithubSource(username: username, completion: {
            source, err in
            if let pageSource = source {
                guard let doc: Document = try? SwiftSoup.parse(pageSource) else { return
                }
                guard let commitElements = try? doc.select("[class=day]") else { return
                }
                
                for i in commitElements {
                    let date = try? i.attr("data-date")
                    print("date + \(date)")
                    if date == nil {
                        continue
                    }
                    
                    let commitsCount = try? i.attr("data-count")
                    let fillColor = try? i.attr("fill")
                    
                    print(date)
                    print("Commits: \(commitsCount)")
                    print()
                }
            }
        })
    } else {
        for i in year...currentYear {
            
        }
    }
    
}

func getGithubSourceForYear(username: String, year: Int, completion: @escaping (String?) -> ()) {
    if let url = URL(string: "https://github.com/\(username)") {
        URLSession.shared.dataTask(with: url) { (data, response, err) in
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

func getYear(myDate: String) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: stringToDate(date: myDate))
    
    if let year = Int(String(components.year!)) {
        return year
    } else {
        return 0
    }
}

func stringToDate(date: String) -> Date {
    print(date)
    let dateFormatter = ISO8601DateFormatter()
    let date = dateFormatter.date(from:date)!
    
    return date
}

func dateToString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    let myString = formatter.string(from: date)
    let yourDate = formatter.date(from: myString)
    formatter.dateFormat = "dd-MMM-yyyy"
    let myStringafd = formatter.string(from: yourDate!)
    
    print(myStringafd)
    return myStringafd
}



