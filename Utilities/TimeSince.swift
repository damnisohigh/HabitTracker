//
//  TimeSince.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 14.04.2025.
//

import Foundation

func timeSince(_ date: Date, now: Date = Date(), shortStyle: Bool = false) -> String {
    let interval = now.timeIntervalSince(date)

    if interval <= 0 {
        return shortStyle ? "0s" : "0 seconds" 
    }

    let formatter = DateComponentsFormatter()
    
    formatter.allowedUnits = [.day, .hour, .minute, .second]
    formatter.unitsStyle = shortStyle ? .abbreviated : .full 
    formatter.maximumUnitCount = shortStyle ? 2 : 2
    
    if shortStyle {
        if interval >= 86400 {
            formatter.allowedUnits = [.day, .hour]
        } else if interval >= 3600 {
            formatter.allowedUnits = [.hour, .minute]
        } else if interval >= 60 {
            formatter.allowedUnits = [.minute, .second]
        } else { // Секунды
            formatter.allowedUnits = [.second]
            formatter.maximumUnitCount = 1 
        }
    }
    
    if let formattedString = formatter.string(from: interval) {
        return formattedString
    } else {
        return "Error formatting time"
    }
}
 

#if os(iOS)
    // iOS 
#elseif os(macOS)
    // macOS
#endif
