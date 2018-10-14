//
//  InterfaceController.swift
//  WorkTimerWatch Extension
//
//  Created by Michael Mahon on 10/13/18.
//  Copyright © 2018 Michael Mahon. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet weak var timeLeftTimer: WKInterfaceTimer!
    @IBOutlet weak var endTimeLbl: WKInterfaceLabel!
    var session = WCSession.default
    var endTime = Date()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        loadEndTime()
        startSession()
    }
    
    override func didAppear() {
        if !session.isReachable {
            startSession()
        }
        setEndTimeLbl()
        startTimer()
        loadEndTime()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func startSession() {
        session = WCSession.default
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        guard let data = NSKeyedUnarchiver.unarchiveObject(with: messageData as! Data) else {
            return
        }
        
        self.endTime = data as! Date
        self.startTimer()
        self.setEndTimeLbl()
        self.saveEndTime()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(activationState)
        session.sendMessage(["requestData": "send_data"], replyHandler: {  ( response )  in
            
            guard let data = NSKeyedUnarchiver.unarchiveObject(with: response["data"] as! Data) else {
                return
            }
            
            self.endTime = data as! Date
            self.startTimer()
            self.setEndTimeLbl()
            self.saveEndTime()
        },
                            errorHandler: {  ( error )  in
                                print ( "Error sending message: % @ " ,  error )
        })
    }
    
    func saveEndTime() {
        
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: endTime), forKey: "END_TIME")
        UserDefaults.standard.synchronize()
    }
    
    func loadEndTime() {
        if (UserDefaults.standard.object(forKey: "END_TIME") as? Data) != nil {
            endTime = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "END_TIME") as! Data) as! Date
        }
    }
    
    func startTimer() {
        timeLeftTimer.stop()
        timeLeftTimer.setDate(endTime)
        timeLeftTimer.start()
    }
    
    func setEndTimeLbl() {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone.current
        
        endTimeLbl.setText(formatter.string(from: endTime))
    }

}
