import UIKit
import SwiftSoup

var str = "Hello, playground"


let formatter = DateFormatter()
// initially set the format based on your datepicker date / server String
formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

let myString = formatter.string(from: Date()) // string purpose I add here
// convert your string to date
let yourDate = Date()
//then again set the date format whhich type of output you need
formatter.dateFormat = "dd-MMM-yyyy"
// again convert your date to string
let myStringafd = formatter.string(from: yourDate)

print(myStringafd)


let myDecimalNumber = 1.25



//Group of elements
//Find date, find dayOfWeek of day
//If it is greater than 0, go backwards till 0
//If it is 

