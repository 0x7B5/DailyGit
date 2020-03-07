import UIKit

var str = "Hello, playground"


struct ContributionList: Codable {
    let contributions: [Contribution]
}

struct Contribution: Codable {
    let date: String
    let count: Int
    //hex color
    let color: String
    let dayOfWeek: Int
    //let intensity: Int
}

if let url = URL(string: "http://127.0.0.1:5000/contributions/vlad-munteanu") {
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                let user = try! JSONDecoder().decode(ContributionList.self, from: data)
                
                for val in user.contributions {
                    print(val)
                }
                
            } catch _ {
                print("err")
            }
        }
    }.resume()
}

