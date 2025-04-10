//
//  HabitListViewModlel.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 27.03.2025.
//
import SwiftUI
import CoreData

class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var currentFilter: HabitFilterType = .all
    
    private var context: NSManagedObjectContext
    
    enum HabitFilterType: String, CaseIterable {
        case all = "All"
        case good = "Good"
        case bad = "Bad"
    }
    
    var filteredHabits: [Habit] {
        switch currentFilter {
        case .all:
            return habits
        case .good:
            return habits.filter { $0.category == "good" }
        case .bad:
            return habits.filter { $0.category == "bad" }
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchHabits()
    }
    
    func fetchHabits() {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.createdAt, ascending: false)]
        
        do {
            habits = try context.fetch(request)
            print("✅Habits loaded successfully!")
        } catch {
            print("❌Error loading habits: \(error.localizedDescription)")
        }
    }

    func addHabit(title: String, habitType: String, goalCount: Int, color: String, category: String) {
        let newHabit = Habit(context: context)
        newHabit.id = UUID()
        newHabit.title = title
        newHabit.habitType = habitType
        newHabit.createdAt = Date()
        newHabit.goalCount = goalCount > 0 ? Int16(goalCount) : 0
        newHabit.currentCount = 0
        newHabit.color = color
        newHabit.isCompleted = false
        newHabit.category = category

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
                        }
                    }
                } else {
                    updatedHabit.isCompleted = true
                }

                try context.save()
                fetchHabits()
            }
        } catch {
            print("❌ Error fetching habit: \(error.localizedDescription)")
        }
    }

    private func saveContext() {
        do {
            try context.save()
            print("✅Context saved successfully!")
        } catch {
            print("❌Error saving context: \(error.localizedDescription)")
        }
    }
}



