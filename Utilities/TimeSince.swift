//
//  TimeSince.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 14.04.2025.
//

import Foundation

func timeSince(_ date: Date, now: Date = Date()) -> String {
    let interval = Int(now.timeIntervalSince(date))
    let hours = interval / 3600
    let minutes = (interval % 3600) / 60
    let second = interval % 60
    
    return String(format: "%02dh %02dm %02ds", hours, minutes, second)
}
