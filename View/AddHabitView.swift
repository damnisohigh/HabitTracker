//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 27.03.2025.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HabitListViewModel
    @State private var title = ""
    @State private var habitType = "Daily"
    @State private var goalCount: String = ""
    @State private var selectedColor = "#FFFFFF"
    @State private var category = "Good"
    
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
                    let goal = Int(goalCount) ?? 0  // Если пользователь не ввел число, будет 0
                    viewModel.addHabit(title: title, habitType: habitType, goalCount: goal, color: selectedColor, category: category)
                    dismiss()
                }
            }
            .navigationTitle("Add Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}


