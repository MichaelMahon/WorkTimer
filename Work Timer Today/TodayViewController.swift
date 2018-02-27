//
//  TodayViewController.swift
//  Work Timer Today
//
//  Created by Michael Mahon on 2/24/18.
//  Copyright © 2018 Michael Mahon. All rights reserved.
//

import UIKit
import NotificationCenter
import Foundation

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var endTimeContainer: UIView!
    @IBOutlet weak var endTimeView: UIView!
    @IBOutlet weak var endTimeLbl: UILabel!
    
    @IBOutlet weak var timeLeftContainer: UIView!
    @IBOutlet weak var timeLeftView: UIView!
    @IBOutlet weak var timeLeftLbl: UILabel!
    
    var timer = Timer()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extensionContext?.widgetMaximumSize(for: .expanded)
        
        let userDefaults = UserDefaults(suiteName: "group.mikemahon.WorkTimer")
        if let savedEndTime = userDefaults?.object(forKey: "SAVED_END_TIME") as? Date {
            let timeSaved = userDefaults?.object(forKey: "TIME_SAVED") as? Date
            if timeSaved != nil && timeSaved!.timeIntervalSinceNow < 80000 {
                endTime = savedEndTime
            }
        }
        
        timeLeftView.layer.borderColor = UIColor.white.cgColor
        timeLeftView.layer.borderWidth = 3
        endTimeView.layer.borderColor = UIColor.white.cgColor
        endTimeView.layer.borderWidth = 3
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        endTimeLbl.text = formatter.string(from: endTime)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .expanded: preferredContentSize.height = 100
        case .compact: preferredContentSize.height = 100
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer.invalidate()
        updateEndTime()
        runTimer()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func updateEndTime() {
        let userDefaults = UserDefaults(suiteName: "group.mikemahon.WorkTimer")
        if let savedEndTime = userDefaults?.object(forKey: "SAVED_END_TIME") as? Date {
            let timeSaved = userDefaults?.object(forKey: "TIME_SAVED") as? Date
            if timeSaved != nil && timeSaved!.timeIntervalSinceNow < 80000 {
                endTime = savedEndTime
            }
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLeft), userInfo: nil, repeats: true)
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
        }
    }
    
}
