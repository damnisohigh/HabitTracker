//
//  TimeSince.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 14.04.2025.
//

import Foundation

func timeSince(_ date: Date, now: Date = Date(), shortStyle: Bool = false) -> String {
    let interval = Int(now.timeIntervalSince(date))
    
    let days = interval / 86400
    let hours = (interval % 86400) / 3600
    let minutes = (interval % 3600) / 60
    let seconds = interval % 60

    if shortStyle {
        if days > 0 {
            return "\(days)d \(hours)h"
        } else if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    } else {
        var components: [String] = []
        if days > 0 { components.append("\(days) day" + (days > 1 ? "s" : "")) }
        if hours > 0 { components.append("\(hours) hour" + (hours > 1 ? "s" : "")) }
        if minutes > 0 { components.append("\(minutes) minute" + (minutes > 1 ? "s" : "")) }
        if seconds > 0 || components.isEmpty { components.append("\(seconds) second" + (seconds > 1 ? "s" : "")) }

        return components.joined(separator: " ")
    }
}
 

#if os(iOS)
    // iOS 
#elseif os(macOS)
    // macOS
#endif
