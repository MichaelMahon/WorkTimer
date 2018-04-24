//
//  EditTimeViewController.swift
//  WorkTimer
//
//  Created by Michael Mahon on 2/22/18.
//  Copyright © 2018 Michael Mahon. All rights reserved.
//

import UIKit
import UserNotifications

class EditTimeViewController: UIViewController {
    
    var selectedEndTime: Date = endTime
    var selectedStartTime: Date = startTime
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var hoursSegmentControl: UISegmentedControl!
    @IBOutlet weak var lunchSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endTimePicker.setDate(endTime, animated: true)
        startTimePicker.setDate(startTime, animated: true)
        startTimePicker.setValue(UIColor.white, forKeyPath: "textColor")
        endTimePicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        endTime = selectedEndTime
        startTime = selectedStartTime
        dateSet = true
        dismissEditVC()
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismissEditVC()
    }
    
    func dismissEditVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startTimePickerChanged(_ sender: Any) {
        updateStartTime()
    }
    
    func updateStartTime() {
        selectedStartTime = startTimePicker.date
        
        selectedEndTime = selectedStartTime.addingTimeInterval(getTimeInterval())
        
        startTimePicker.setDate(selectedStartTime, animated: true)
        endTimePicker.setDate(selectedEndTime, animated: true)
    }
    
    @IBAction func endTimePickerChanged(_ sender: Any) {
        updateEndTime()
    }
    
    func updateEndTime() {
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let endTimePickerDate = endTimePicker.date
        let hour = calendar.component(.hour, from: endTimePickerDate)
        let minutes = calendar.component(.minute, from: endTimePickerDate)

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone.current
        dateComponents.hour = hour
        dateComponents.minute = minutes
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let newEndTime = userCalendar.date(from: dateComponents)
        
        selectedEndTime = newEndTime! //endTimePicker.date
        selectedStartTime = selectedEndTime.addingTimeInterval((getTimeInterval() * -1))
        
        startTimePicker.setDate(selectedStartTime, animated: true)
        endTimePicker.setDate(selectedEndTime, animated: true)
        
        print("Start: \(selectedStartTime) END: \(selectedEndTime)")
        
        let content = UNMutableNotificationContent()
        content.title = "Only One Hour Left!"
        content.body = "Just sixty minutes left. You can do it!"
        content.sound = UNNotificationSound.default()
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: (newEndTime?.addingTimeInterval(-3600))!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                    repeats: false)
        
        let identifier = "HourLeftNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
        
        let timesUpContent = UNMutableNotificationContent()
        timesUpContent.title = "Time to go!"
        timesUpContent.body = "Head for the door. Its time to blow this ham shack"
        timesUpContent.sound = UNNotificationSound.default()
        
        let timesUpTriggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: (newEndTime?.addingTimeInterval(-3600))!)
        let timesUpTrigger = UNCalendarNotificationTrigger(dateMatching: timesUpTriggerDate,
                                                    repeats: false)
        
        let timesUpIdentifier = "HourLeftNotification"
        let timesUpRequest = UNNotificationRequest(identifier: timesUpIdentifier,
                                            content: timesUpContent, trigger: timesUpTrigger)
        
        center.add(timesUpRequest, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    func getTimeInterval() -> Double {
        var timeInterval = 0.0
        
        if hoursSegmentControl.selectedSegmentIndex != 3 {
            let hoursString = hoursSegmentControl.titleForSegment(at: hoursSegmentControl.selectedSegmentIndex)
            var hours = 0.0
            if hoursString != nil {
                hours = Double(hoursString!)!
                if lunchSwitch.isOn {
                    hours += 0.5
                }
                timeInterval = hours * 60.0 * 60.0
            }
        }
        return timeInterval
    }
    
    @IBAction func hoursSegmentChanged(_ sender: Any) {
        updateStartTime()
    }
    @IBAction func lunchSwitchChanged(_ sender: Any) {
        updateStartTime()
    }
    
}
