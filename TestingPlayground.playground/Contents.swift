import UIKit

var str = "Hello, playground"


func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(timeElapsed) s.")
}

func timeElapsedInSecondsWhenRunningCode(operation: ()->()) -> Double {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    return Double(timeElapsed)
}

//printTimeElapsedWhenRunningCode(title:"Daily Commits") {
//    if let url = URL(string: "http://127.0.0.\(username)?tab=overview&from=\(2020)-12-01&to=\(2020)-12-31") {
//        URLSession.shared.dataTask(with: url) { (data, response, err) in
//            guard let data = data else {
//                completion(nil)
//                return
//            }
//
//
//            guard let htmlString = String(data: data, encoding: .utf8) else {
//                print("couldn't cast data into String")
//                completion(nil)
//                return
//            }
//            completion(htmlString)
//
//        }.resume()
//    }
//}


func stringToDate(myDate: String, IsoFormat: Bool) -> Date {
    let formatter = DateFormatter()
    if IsoFormat {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    } else {
        formatter.dateFormat = "yyyy-MM-dd"
    }
    
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    
    let date = formatter.date(from: myDate)
    
    if date != nil {
        return date!
    }
    return Date()
}

let date = Date()
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd"
let result = formatter.string(from: date)
print(result)
