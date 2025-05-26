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
    
    func addHabit(title: String, details: String, type: String, goalCount: Int16, color: String, category: String) {
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
        
        if category == badHabitCategoryString {
            newHabit.lastResetDate = Date()
            newHabit.longestAbstinenceDuration = 0
            newHabit.totalAbstinenceDuration = 0
            newHabit.abstinencePeriodsCount = 0
        }

        saveContext()
        fetchHabits()
    }

    func deleteHabit(_ habit: Habit) {
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
                        }
                    }
                } else {
                    updatedHabit.isCompleted = true
                    updatedHabit.lastCompletedDate = Date() 
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
    
    func updateHabit(habit: Habit, title: String, details: String, type: String, goalCount: Int16, color: String, category: String) {
        habit.title = title
        habit.details = details
        habit.habitType = type
        habit.goalCount = goalCount
        habit.color = color
        habit.category = category
        
        saveContext()
        fetchHabits()
    }
}

#if os(iOS)
    // iOS 
#elseif os(macOS)
    // macOS
#endif
