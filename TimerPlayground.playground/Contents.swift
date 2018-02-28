//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
let startTime = Date()//dateFormatter.date(from: "2018-02-27 11:51:34")
let endTime = dateFormatter.date(from: "2018-02-27 11:51:34")

let calendar = NSCalendar.current
let components = calendar.dateComponents([.second], from: Date(), to: endTime!)

let time = components.second
