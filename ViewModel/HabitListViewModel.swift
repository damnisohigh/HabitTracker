//
//  HabitListViewModlel.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 14.04.2025.
//

import Foundation
import CoreData
import SwiftUI // Для Color

class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var currentFilter: HabitFilterType = .all
    @Published var typeFilter: HabitTypeFilter = .all
    
    private let context: NSManagedObjectContext
    private let badHabitCategoryString = "Bad" // Определяем строку для плохой привычки

    enum HabitFilterType: String, CaseIterable {
        case all = "All"
        case good = "Good"
        case bad = "Bad"
    }

    enum HabitTypeFilter: String, CaseIterable {
        case all = "All"
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
    }

    var filteredHabits: [Habit] {
        habits.filter { habit in
            let categoryMatch: Bool
            switch currentFilter {
            case .all:
                categoryMatch = true
            case .good:
                categoryMatch = (habit.category != badHabitCategoryString)
            case .bad:
                categoryMatch = (habit.category == badHabitCategoryString)
            }
            
            let typeMatch = typeFilter == .all || habit.habitType == typeFilter.rawValue
            return categoryMatch && typeMatch
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchHabits()
        checkAndResetHabitsCompletion()
    }
    
    func fetchHabits() {
        let request = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.createdAt, ascending: true)]
        do {
            habits = try context.fetch(request)
        } catch {
            print("❌ Ошибка при выборке привычек: \(error.localizedDescription)")
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
            print("✅ Контекст сохранен!")
        } catch {
            print("❌ Ошибка при сохранении контекста: \(error.localizedDescription)")
        }
    }
    
    private func scheduleOrCancelNotification(for habit: Habit) {
        guard let habitId = habit.id?.uuidString else {
            print("❌ Habit ID is nil, cannot schedule or cancel notification.")
            return
        }
        
        let globalNotificationsOn = UserDefaults.standard.object(forKey: SettingsKeys.globalNotificationsEnabled) as? Bool ?? true
        
        if habit.notificationsEnabled && globalNotificationsOn {
            let title = habit.title ?? "Habit Reminder"
            let body = "Don't forget to complete your habit: \(habit.title ?? "")"
            
            var weekday: Int? = nil
            var day: Int? = nil
            let calendar = Calendar.current
            
            if habit.habitType == "Weekly" {
                // For weekly habits, use the weekday of creation.
                // Weekday: 1 = Sunday, 2 = Monday, ..., 7 = Saturday
                weekday = calendar.component(.weekday, from: habit.createdAt ?? Date())
            } else if habit.habitType == "Monthly" {
                // For monthly habits, use the day of the month of creation.
                day = calendar.component(.day, from: habit.createdAt ?? Date())
            }
            // For "Daily" habits, weekday and day remain nil, so it repeats daily at the specified time.

            NotificationManager.shared.scheduleNotification(
                habitId: habitId,
                title: title,
                body: body,
                hour: Int(habit.notificationHour),
                minute: Int(habit.notificationMinute),
                weekday: weekday,
                day: day,
                repeats: true 
            )
        } else {
            NotificationManager.shared.cancelNotification(habitId: habitId)
        }
    }
    
    func addHabit(title: String, details: String, type: String, goalCount: Int16, color: String, category: String, notificationsEnabled: Bool, notificationHour: Int16, notificationMinute: Int16) {
        let newHabit = Habit(context: context)
        newHabit.id = UUID()
        newHabit.title = title
        newHabit.details = details
        newHabit.habitType = type
        newHabit.createdAt = Date()
        newHabit.goalCount = goalCount
        newHabit.currentCount = 0
        newHabit.color = color
        newHabit.isCompleted = false
        newHabit.category = category
        newHabit.notificationsEnabled = notificationsEnabled
        newHabit.notificationHour = notificationHour
        newHabit.notificationMinute = notificationMinute
        
        if category == badHabitCategoryString {
            newHabit.lastResetDate = Date()
            newHabit.longestAbstinenceDuration = 0
            newHabit.totalAbstinenceDuration = 0
            newHabit.abstinencePeriodsCount = 0
        }

        saveContext()
        fetchHabits()
        scheduleOrCancelNotification(for: newHabit)
    }

    func deleteHabit(_ habit: Habit) {
        if let habitId = habit.id?.uuidString {
            NotificationManager.shared.cancelNotification(habitId: habitId)
        }
        context.delete(habit)
        saveContext()
        fetchHabits()
    }
    
    func markHabitAsCompleted(_ habit: Habit) {
        let habitID = habit.objectID 

        do {
            if let updatedHabit = try context.existingObject(with: habitID) as? Habit {
                objectWillChange.send()
                
                if updatedHabit.goalCount > 0 {
                    if updatedHabit.currentCount < updatedHabit.goalCount {
                        updatedHabit.currentCount += 1
                        if updatedHabit.currentCount == updatedHabit.goalCount {
                            updatedHabit.isCompleted = true
                            updatedHabit.lastCompletedDate = Date()
                            if updatedHabit.notificationsEnabled {
                                if let habitId = updatedHabit.id?.uuidString {
                                    NotificationManager.shared.cancelNotification(habitId: habitId)
                                    print("Cancelled notification for completed habit: \(updatedHabit.title ?? "")")
                                }
                            }
                        }
                    }
                } else {
                    updatedHabit.isCompleted = true
                    updatedHabit.lastCompletedDate = Date()
                    if updatedHabit.notificationsEnabled {
                         if let habitId = updatedHabit.id?.uuidString {
                            NotificationManager.shared.cancelNotification(habitId: habitId)
                            print("Cancelled notification for completed habit: \(updatedHabit.title ?? "")")
                        }
                    }
                }

                try context.save()
                fetchHabits()
            }
        } catch {
            print("❌ Error fetching habit: \(error.localizedDescription)")
        }
    }
    
    func resetBadHabit(_ habit: Habit) {
        guard habit.category == badHabitCategoryString else { return } 
        
        let habitID = habit.objectID
        
        do {
            if let updatedHabit = try context.existingObject(with: habitID) as? Habit {
                objectWillChange.send()
                
                if let lastReset = updatedHabit.lastResetDate {
                    let currentAbstinenceDuration = Date().timeIntervalSince(lastReset)
                    
                    updatedHabit.totalAbstinenceDuration += currentAbstinenceDuration
                    updatedHabit.abstinencePeriodsCount += 1
                    
                    if currentAbstinenceDuration > updatedHabit.longestAbstinenceDuration {
                        updatedHabit.longestAbstinenceDuration = currentAbstinenceDuration
                    }
                }
                
                updatedHabit.lastResetDate = Date() 
                
                try context.save()
                fetchHabits()
                print("🔁Reset bad habit timer and updated abstinence stats")
            }
        } catch {
            print("❌ Error reseting bad habit: \(error.localizedDescription)")
        }
    }
    
    func updateHabit(habit: Habit, title: String, details: String, type: String, goalCount: Int16, color: String, category: String, notificationsEnabled: Bool, notificationHour: Int16, notificationMinute: Int16) {
        habit.title = title
        habit.details = details
        habit.habitType = type
        habit.goalCount = goalCount
        habit.color = color
        habit.category = category
        habit.notificationsEnabled = notificationsEnabled
        habit.notificationHour = notificationHour
        habit.notificationMinute = notificationMinute
        
        saveContext()
        fetchHabits()
        scheduleOrCancelNotification(for: habit)
    }

    func checkAndResetHabitsCompletion() {
        let calendar = Calendar.current
        let now = Date()
        var habitsDidChange = false

        for habit in habits {
            guard let lastReset = habit.lastResetDate else {
                // If lastResetDate is nil, set it to now and continue (for newly created habits)
                habit.lastResetDate = now
                habitsDidChange = true
                continue
            }

            var shouldReset = false
            if habit.habitType == "Daily" {
                if !calendar.isDateInToday(lastReset) {
                    shouldReset = true
                }
            } else if habit.habitType == "Weekly" {
                if !calendar.isDate(lastReset, equalTo: now, toGranularity: .weekOfYear) {
                    shouldReset = true
                }
            } else if habit.habitType == "Monthly" {
                if !calendar.isDate(lastReset, equalTo: now, toGranularity: .month) {
                    shouldReset = true
                }
            }

            if shouldReset {
                habit.isCompleted = false
                habit.currentCount = 0
                habit.lastResetDate = now // Update last reset date
                habitsDidChange = true
                print("Reset habit: \(habit.title ?? "Unknown")")

                // Reschedule notification if it's enabled and habit is not a "Bad" habit
                // (Bad habits don't get "completed" in the same way and don't need reminders to "do" them)
                if habit.notificationsEnabled && habit.category != badHabitCategoryString && !habit.isCompleted {
                    scheduleOrCancelNotification(for: habit)
                    print("Rescheduled notification for reset habit: \(habit.title ?? "")")
                }
            }
        }

        if habitsDidChange {
            saveContext()
            fetchHabits() // Refetch to update UI if needed
            print("Habit completion statuses checked and reset where necessary.")
        }
    }
}

#if os(iOS)
    // iOS 
#elseif os(macOS)
    // macOS
#endif
