import UIKit
import SwiftSoup

var str = "Hello, playground"

func setupContributions(startDay: String, username: String, completion: () -> ()) {
   
    
    var year = getYear(myDate: startDay)
    
    var currentYear = getYear(myDate: Date())
    
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

func stringToDate(myDate: String) -> Date? {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale.current
    return dateFormatter.date(from: myDate)
    
}


func getYear(myDate: String) -> Int {
    let calendar = Calendar.current
    if let date = stringToDate(myDate: myDate){
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        if let year = Int(String(components.year!)) {
            return year
        }
    }
    return 0
}

func getYear(myDate: Date) -> Int {
     let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: myDate)
    let year = Int(String(components.year!)) ?? 0
    return year
}


print(Date())
print(getFormattedDate())
let dateRN = getFormattedDate()

stringToDate(myDate: "2019-02-12")



