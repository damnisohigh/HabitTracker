//
//  HabitListViewModlel.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 27.03.2025.
//
import SwiftUI
import CoreData

class HabitListViewModlel: ObservableObject {
    @Published var habits: [Habit] = []
    private var context: NSManagedObjectContext
    
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

    func addHabit(title: String, habitType: String, goalCount: Int, color: String) {
        let newHabit = Habit(context: context)
        newHabit.id = UUID()
        newHabit.title = title
        newHabit.habitType = habitType
        newHabit.createdAt = Date()
        newHabit.goalCount = Int16(goalCount)
        newHabit.currentCount = 0
        newHabit.color = color
        newHabit.isCompleted = false

        saveContext()
        fetchHabits()
    }

    func deleteHabit(_ habit: Habit) {
        context.delete(habit)
        saveContext()
        fetchHabits()
    }
    
    func markHabitAsCompleted(_ habit: Habit) {
        let habitID = habit.objectID // Получаем уникальный ID объекта

        do {
            if let updatedHabit = try context.existingObject(with: habitID) as? Habit {
                objectWillChange.send() // Сообщаем SwiftUI об изменениях
                
                if updatedHabit.currentCount < updatedHabit.goalCount {
                    updatedHabit.currentCount += 1
                    if updatedHabit.currentCount == updatedHabit.goalCount {
                        updatedHabit.isCompleted = true
                    }
                    try context.save() 
                    fetchHabits()
                }
            }
        } catch {
            print("❌Error fetching habit: \(error.localizedDescription)")
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



