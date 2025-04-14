//
//  TimeSince.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 14.04.2025.
//

import Foundation

func timeSince(_ date: Date) -> String {
    let interval = Date().timeIntervalSince(date)
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.day, .hour, .minute, .second]
    formatter.unitsStyle = .abbreviated
    return formatter.string(from: interval) ?? "Just now"
}
