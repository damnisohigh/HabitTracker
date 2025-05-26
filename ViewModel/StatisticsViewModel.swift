//
//  StatisticsViewModel.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 22.05.2025.
//

import Foundation

final class StatisticsViewModel: ObservableObject {
    
    enum StatKey: Hashable {
        case kind(HabitKind)
        case frequency(HabitFrequency)
    }

    enum HabitKind: String, CaseIterable {
        case good = "Good"
        case bad = "Bad"
    }

    enum HabitFrequency: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
    }

    @Published var stats: [StatKey: (Int, Int, Double)] = [:]
    @Published var badHabitStats: (longestStreak: TimeInterval, averageStreak: TimeInterval)?
    @Published var createdHabitsCountByFrequency: [HabitFrequency: Int] = [:]

    private let badHabitCategoryString = "Bad"

    func update(with habits: [Habit]) {
        var newStats: [StatKey: (Int, Int, Double)] = [:]
        var newCreatedCounts: [HabitFrequency: Int] = [:]

        // By Kind (Good, Bad)
        for kind in HabitKind.allCases {
            let filteredHabits: [Habit]
            if kind == .good {
                filteredHabits = habits.filter { $0.category != badHabitCategoryString }
            } else { 
                filteredHabits = habits.filter { $0.category == badHabitCategoryString }
            }
            
            let total = filteredHabits.count
            let completed: Int = (kind == .bad) ? 0 : filteredHabits.filter { $0.isCompletedToday }.count
            let percentage = total > 0 ? Double(completed) / Double(total) : 0.0
            newStats[.kind(kind)] = (total, completed, percentage)
        }
        
        // By Frequency
        for frequency in HabitFrequency.allCases {
            let filteredByFrequency = habits.filter { $0.habitType == frequency.rawValue }
            let total = filteredByFrequency.count
            let completed = filteredByFrequency.filter { $0.isCompletedToday && $0.category != badHabitCategoryString }.count
            let percentage = total > 0 ? Double(completed) / Double(total) : 0.0
            newStats[.frequency(frequency)] = (total, completed, percentage)
            
            var createdCount = 0
            switch frequency {
            case .daily:
                createdCount = filteredByFrequency.filter { Calendar.current.isDateInToday($0.createdAt ?? Date.distantPast) }.count
            case .weekly:
                createdCount = filteredByFrequency.filter { Calendar.current.isDate($0.createdAt ?? Date.distantPast, equalTo: Date(), toGranularity: .weekOfYear) }.count
            case .monthly:
                createdCount = filteredByFrequency.filter { Calendar.current.isDate($0.createdAt ?? Date.distantPast, equalTo: Date(), toGranularity: .month) }.count
            }
            newCreatedCounts[frequency] = createdCount
        }

        DispatchQueue.main.async {
            self.stats = newStats
            self.createdHabitsCountByFrequency = newCreatedCounts
        }

        computeHistoricalBadHabitAnalytics(from: habits)
    }

    private func computeHistoricalBadHabitAnalytics(from habits: [Habit]) {
        let badCategoryHabits = habits.filter { $0.category == badHabitCategoryString }

        if badCategoryHabits.isEmpty {
            DispatchQueue.main.async {
                self.badHabitStats = nil
            }
            return
        }

        var overallLongestAbstinence: TimeInterval = 0
        var overallTotalAbstinenceSum: TimeInterval = 0 
        var overallAbstinencePeriodsCount: Int64 = 0 

        for habit in badCategoryHabits {
            if habit.longestAbstinenceDuration > overallLongestAbstinence {
                overallLongestAbstinence = habit.longestAbstinenceDuration
            }
            overallTotalAbstinenceSum += habit.totalAbstinenceDuration
            overallAbstinencePeriodsCount += habit.abstinencePeriodsCount
        }
        
        let averageAbstinence = overallAbstinencePeriodsCount > 0 ? (overallTotalAbstinenceSum / Double(overallAbstinencePeriodsCount)) : 0

        DispatchQueue.main.async {
            if overallAbstinencePeriodsCount > 0 || overallLongestAbstinence > 0 { 
                 self.badHabitStats = (longestStreak: overallLongestAbstinence, averageStreak: averageAbstinence)
            } else {
                 self.badHabitStats = nil
            }
        }
    }

    func formattedDuration(from interval: TimeInterval) -> String {
        let totalMinutes = Int(interval) / 60
        let days = totalMinutes / (24 * 60)
        let hours = (totalMinutes % (24 * 60)) / 60
        let minutes = totalMinutes % 60

        var parts: [String] = []
        if days > 0 { parts.append("\(days)д") }
        if hours > 0 || days > 0 { parts.append("\(hours)ч") } 
        if minutes > 0 || (days == 0 && hours == 0) { parts.append("\(minutes)м") }

        return parts.isEmpty ? "0м" : parts.joined(separator: " ")
    }
}
