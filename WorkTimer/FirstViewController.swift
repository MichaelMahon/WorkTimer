//
//  FirstViewController.swift
//  WorkTimer
//
//  Created by Michael Mahon on 2/22/18.
//  Copyright © 2018 Michael Mahon. All rights reserved.
//

import UIKit
import UserNotifications

class FirstViewController: UIViewController {
    
    
    @IBOutlet weak var timeLeftContainer: UIView!
    @IBOutlet weak var timeLeftView: UIView!
    @IBOutlet weak var timeLeftLbl: UILabel!
    
    @IBOutlet weak var endTimeContainer: UIView!
    @IBOutlet weak var endTimeView: UIView!
    @IBOutlet weak var endTimeLbl: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedEndTime = UserDefaults.standard.object(forKey: "SAVED_END_TIME") as? Date {
            let timeSaved = UserDefaults.standard.object(forKey: "TIME_SAVED") as? Date
            if timeSaved != nil {
                endTime = savedEndTime
                dateSet = true
            }
        }
        
        timeLeftView.layer.borderColor = UIColor.white.cgColor
        timeLeftView.layer.borderWidth = 3
        
        endTimeView.layer.borderColor = UIColor.white.cgColor
        endTimeView.layer.borderWidth = 3
        
        editBtn.layer.borderColor = UIColor.white.cgColor
        editBtn.layer.borderWidth = 3
        clearBtn.layer.borderColor = UIColor.white.cgColor
        clearBtn.layer.borderWidth = 3
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!dateSet) {
            performSegue(withIdentifier: "EditTime", sender: nil)
        } else {
            timer.invalidate()
            updateEndTime()
            runTimer()
        }
    }
    
    func updateEndTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        endTimeLbl.text = formatter.string(from: endTime)
        
        UserDefaults.standard.set(endTime, forKey: "SAVED_END_TIME")
        UserDefaults.standard.set(Date(), forKey: "TIME_SAVED")
        
        scheduleNotifications()
        
        if let userDefaults = UserDefaults(suiteName: "group.mikemahon.WorkTimer") {
            userDefaults.set(endTime, forKey: "SAVED_END_TIME")
            userDefaults.set(Date(), forKey: "TIME_SAVED")
            userDefaults.synchronize()
        }
    }
    
    @objc func updateTimeLeft() {
        timeLeft = timeLeft.addingTimeInterval(-1)
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.second], from: Date(), to: endTime)

        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss"
        
        let time = components.second!
        
        if (time >= 0) {
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            let timeString = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            
            timeLeftLbl.text = timeString
        } else {
            timeLeftLbl.text = EMPTY_DATE
            timer.invalidate()
            
            if let userDefaults = UserDefaults(suiteName: "group.mikemahon.WorkTimer") {
                userDefaults.removeObject(forKey: "SAVED_END_TIME")
                userDefaults.set(Date(), forKey: "TIME_SAVED")
                userDefaults.synchronize()
            }
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLeft), userInfo: nil, repeats: true)
    }
    
    @IBAction func swipedLeft(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        let hourLeftNotificationIdentifier = "HourLeftNotification"
        let hourLeftNotificationContent = UNMutableNotificationContent()
        hourLeftNotificationContent.title = "Only One Hour Left!"
        hourLeftNotificationContent.body = "Just sixty minutes left. You can do it!"
        hourLeftNotificationContent.sound = UNNotificationSound.default()
        
        let hourLeftNotificationTriggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: (endTime.addingTimeInterval(-3600)))
        let hourLeftNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: hourLeftNotificationTriggerDate, repeats: false)
        
        let hourLeftNotificationRequest = UNNotificationRequest(identifier: hourLeftNotificationIdentifier, content: hourLeftNotificationContent, trigger: hourLeftNotificationTrigger)
        
        center.add(hourLeftNotificationRequest, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
        
        let timesUpNotificationContent = UNMutableNotificationContent()
        timesUpNotificationContent.title = "Time to go!"
        timesUpNotificationContent.body = "Head for the door. Its time to blow this ham shack"
        timesUpNotificationContent.sound = UNNotificationSound.default()

        let timesUpNotificationTriggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: endTime)
        let timesUpNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: timesUpNotificationTriggerDate, repeats: false)

        let timesUpNotificationIdentifier = "TimeToGoNotification"
        let timesUpNotificationRequest = UNNotificationRequest(identifier: timesUpNotificationIdentifier, content: timesUpNotificationContent, trigger: timesUpNotificationTrigger)
        
        center.add(timesUpNotificationRequest, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    @IBAction func clearBtnTapped(_ sender: Any) {
        clearAndRestartTimer()
    }
    
    func clearAndRestartTimer() {
        endTime = Date().addingTimeInterval(8.5 * 60.0 * 60.0)
        dateSet = false
        timer.invalidate()
        updateEndTime()
        runTimer()
    }
    
}

