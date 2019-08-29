import UIKit
import SwiftSoup

var str = "Hello, playground"

func setupContributions(startDay: String, username: String, completion: () -> ()) {
    
    
    var year = getYear(myDate: startDay)
    var currentYear = getYear(myDate: getFormattedDate())
    
    //user created account this year
    if year == currentYear {
        print("same")
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
                    print("Commits: \(String(describing: commitsCount))")
                    print()
                }
            }
        })
    } else {
        for i in year...currentYear {
            print(i)
            getGithubSourceForYear(username: username, year: i, completion: {
                source in
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
                        
                        //                        if getYear(myDate: date!) != year {
                        //                           // continue
                        //                        }
                        
                        
                        let commitsCount = try? i.attr("data-count")
                        let fillColor = try? i.attr("fill")
                        
                        print(date!)
                        //print("Commits: \(commitsCount)")
                        
                        
                    }
                }
            })
        }
    }
    
}

//https://github.com/vlad-munteanu?tab=overview&from=2018-12-01&to=2018-12-31
//Default website is fine for current year

func getGithubSourceForYear(username: String, year: Int, completion: @escaping (String?) -> ()) {
    if let url = URL(string: "https://github.com/\(username)?tab=overview&from=\(year)-12-01&to=\(year)-12-31") {
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

func stringToDate(myDate: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    
    let date = formatter.date(from: myDate)
    
    if date != nil {
        return date!
    }
    return Date()
}


func getYear(myDate: String) -> Int {
    let calendar = Calendar.current
    let date = stringToDate(myDate: myDate)
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    if let year = Int(String(components.year!)) {
        return year
    }
    
    return 0
}

func getYear(myDate: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: myDate)
    let year = Int(String(components.year!)) ?? 0
    return year
}

stringToDate(myDate: "2018-04-12")

setupContributions(startDay: "2018-04-12T14:47:49Z", username: "vlad-munteanu", completion: {
    
})


