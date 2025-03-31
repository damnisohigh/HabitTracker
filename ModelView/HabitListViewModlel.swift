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
        } catch {
            print("❌ Error loading habits: \(error.localizedDescription)")
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

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("❌ Error saving context: \(error.localizedDescription)")
        }
    }
}



