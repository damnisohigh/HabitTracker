//
//  HabitFormView.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 27.03.2025.
//

import SwiftUI

struct HabitFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HabitListViewModel

    let habitToEdit: Habit?

    @State private var title: String = ""
    @State private var habitType: String = "Daily"
    @State private var goalCount: String = ""
    @State private var selectedColor: String = "#FFFFFF"
    @State private var category: String = "Good"

    var body: some View {
        NavigationView {
            Form {
                TextField("Habit Name", text: $title)

                Picker("Habit Type", selection: $habitType) {
                    Text("Daily").tag("Daily")
                    Text("Weekly").tag("Weekly")
                    Text("Monthly").tag("Monthly")
                }

                Picker("Category", selection: $category) {
                    Text("Good").tag("Good")
                    Text("Bad").tag("Bad")
                }

                TextField("Goal (optional)", text: $goalCount)
                    .keyboardType(.numberPad)

                ColorPicker("Choose Color", selection: Binding(
                    get: { Color(hex: selectedColor) },
                    set: { selectedColor = $0.toHex() }
                ))

                Button("Save") {
                    let goal = Int(goalCount) ?? 0

                    if let habit = habitToEdit {
                        viewModel.updateHabit(
                            habit: habit,
                            title: title,
                            habitType: habitType,
                            goalCount: goal,
                            color: selectedColor,
                            categoty: category
                        )
                    } else {
                        viewModel.addHabit(
                            title: title,
                            habitType: habitType,
                            goalCount: goal,
                            color: selectedColor,
                            category: category
                        )
                    }

                    dismiss()
                }
            }
            .navigationTitle(habitToEdit == nil ? "Add Habit" : "Edit Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let habit = habitToEdit {
                    title = habit.title ?? ""
                    habitType = habit.habitType ?? "Daily"
                    goalCount = habit.goalCount > 0 ? "\(habit.goalCount)" : ""
                    selectedColor = habit.color ?? "#FFFFFF"
                    category = habit.category ?? "Good"
                }
            }
        }
    }
}


#if os(iOS)
    // iOS 
#elseif os(macOS)
    // macOS
#endif
