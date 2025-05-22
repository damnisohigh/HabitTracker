//
//  StatisticsViewModel.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 22.05.2025.
//

import Foundation
import CoreData

class StatisticsViewModel: ObservableObject {
    @Published var habits: [Habit] = []

    init(habits: [Habit]) {
        self.habits = habits
    }

    enum HabitType: String {
        case daily, weekly, monthly
    }

    func habits(for type: HabitType) -> [Habit] {
        return habits.filter { $0.habitType == type.rawValue }
    }

    func completedHabits(for type: HabitType) -> [Habit] {
        return habits(for: type).filter { $0.isCompletedToday }
    }

    func completionRate(for type: HabitType) -> Double {
        let total = habits(for: type).count
        let completed = completedHabits(for: type).count
        guard total > 0 else { return 0.0 }
        return Double(completed) / Double(total)
    }

    func totalCount(for type: HabitType) -> Int {
        return habits(for: type).count
    }

    func completedCount(for type: HabitType) -> Int {
        return completedHabits(for: type).count
    }
}


