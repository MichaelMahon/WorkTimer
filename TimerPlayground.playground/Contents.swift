//: Playground - noun: a place where people can play

import UIKit

let email = "feedback@buoycast.com"
let subject = "Buoycast Feedback"
let body = "%0A%0A%0A%0A%0A%0A" +
    "Device Information:%0A" +
    "Device: Iphone X%0A" +
    "iOS Version: 11.3%0A" +
    "Buoycast Version: 2.0%0A" +
    "Unlocked Buoycast Pro: true%0A" +
    "Push Notifications Enabled: true%0A" +
"Push Notification ID: fewfwefwefwefwdfdsffsdf"

var emailString = email + subject + body

emailString = emailString.replacingOccurrences(of: " ", with: "%20")

if let url = URL(string: email + subject + body) {
    print(url)
    UIApplication.shared.open(url)
}
