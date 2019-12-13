import UIKit

let formatter = DateFormatter()
formatter.dateFormat = "yyyy/MM/dd HH:mm"
let someDateTime = formatter.date(from: "2016/10/08 22:31")
print(someDateTime)
