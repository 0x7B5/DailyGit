import UIKit
import SwiftSoup

var str = "Hello, playground"

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate

        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}


func getFormattedStringDate() -> String {
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
    
    //print(currentDate)
    return currentDate
}

func getCommitsForDate(username: String, date: String, completion: @escaping (Int?) -> ()) {
    
    getGithubSource(username: username, completion: {
        source, err in
        if let pageSource = source {
            guard let doc: Document = try? SwiftSoup.parse(pageSource) else { return }
            guard let elements = try? doc.select("[class=day]") else { return }
            for i in elements {
                //print(i)
            }
            
            //print(pageSource)
           // print(pageSource)
            let leftSideString = """
                              " data-count="
                              """
            
            let rightSideString = """
            " data-date="\(date)"/>
            """
            
            //print(rightSideString)
            
            guard
                let rightSideRange = pageSource.range(of: rightSideString)
                else {
                    print("couldn't find right range")
                    completion(nil)
                    return
            }
            
            let rangeOfTheData = pageSource.index(rightSideRange.lowerBound, offsetBy: -26)..<rightSideRange.lowerBound
            let subPageSource = pageSource[rangeOfTheData]
            // print(subPageSource)
            
            
            guard
                let leftSideRange = subPageSource.range(of: leftSideString)
                else {
                    print("couldn't find left range")
                    completion(nil)
                    return
            }
            
            let finalRange = leftSideRange.upperBound..<subPageSource.endIndex
            let commitsValueString = subPageSource[finalRange]
            
            // print(commitsValueString)
            if let commitsValueInt = Int(commitsValueString) {
                completion(commitsValueInt)
            } else {
                completion(nil)
            }
        }
    })
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

func stringToDate(date: String) -> Date {
    print(date)
    #warning("somethig")
    let dateFormatter = ISO8601DateFormatter()
    let date = dateFormatter.date(from:date)!
    
    return date
}

func setupContributions(startDay: String, username: String, completion: () -> ()) {
    
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: stringToDate(date: startDay))
    
    let year = String(components.year!)
    print(year)

}


func randYear(startDay: String) {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: stringToDate(date: startDay))
    
    let year = String(components.year!)
    print(year)
}

