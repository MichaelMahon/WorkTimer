//
//  Data.swift
//  WorkTimer
//
//  Created by Michael Mahon on 2/23/18.
//  Copyright © 2018 Michael Mahon. All rights reserved.
//

import Foundation

var endTime = Date().addingTimeInterval(8.5 * 60.0 * 60.0)
var startTime = endTime.addingTimeInterval(-8.5 * 60.0 * 60.0)
var dateSet = false
let EMPTY_DATE = "00:00:00"
var timeLeft = Date().addingTimeInterval(8.0 * 60.0 * 60.0)
