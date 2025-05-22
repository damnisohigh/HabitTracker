//
//  Habit+Extensions.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 22.05.2025.
//

import Foundation

extension Habit {
    var isCompletedToday: Bool {
        guard let lastDate = lastCompletedDate else { return false }
        return Calendar.current.isDateInToday(lastDate)
    }
}
