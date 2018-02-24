//
//  EditTimeViewController.swift
//  WorkTimer
//
//  Created by Michael Mahon on 2/22/18.
//  Copyright © 2018 Michael Mahon. All rights reserved.
//

import UIKit

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
        selectedEndTime = endTimePicker.date
        selectedStartTime = selectedEndTime.addingTimeInterval((getTimeInterval() * -1))
        
        startTimePicker.setDate(selectedStartTime, animated: true)
        endTimePicker.setDate(selectedEndTime, animated: true)
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
