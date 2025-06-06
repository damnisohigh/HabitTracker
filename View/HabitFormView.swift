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
    @State private var details: String = ""
    @State private var habitType: String = "Daily"
    @State private var goalCount: String = ""
    @State private var selectedColor: String = "#FFFFFF"
    @State private var category: String = "Good"
    @State private var notificationsEnabled: Bool = false
    @State private var notificationTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()

    var body: some View {
        NavigationView {
            Form {
                TextField("Habit Name", text: $title)
                TextField("Details (optional)", text: $details)

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

                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    if notificationsEnabled {
                        DatePicker("Reminder Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                    }
                }

                Button("Save") {
                    let goal: Int16 = Int16(goalCount) ?? 0
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: notificationTime)
                    let minute = calendar.component(.minute, from: notificationTime)

                    if let habit = habitToEdit {
                        viewModel.updateHabit(
                            habit: habit,
                            title: title,
                            details: details,
                            type: habitType,
                            goalCount: goal,
                            color: selectedColor,
                            category: category,
                            notificationsEnabled: notificationsEnabled,
                            notificationHour: Int16(hour),
                            notificationMinute: Int16(minute)
                        )
                    } else {
                        viewModel.addHabit(
                            title: title,
                            details: details,
                            type: habitType,
                            goalCount: goal,
                            color: selectedColor,
                            category: category,
                            notificationsEnabled: notificationsEnabled,
                            notificationHour: Int16(hour),
                            notificationMinute: Int16(minute)
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
                    details = habit.details ?? ""
                    habitType = habit.habitType ?? "Daily"
                    goalCount = habit.goalCount > 0 ? "\(habit.goalCount)" : ""
                    selectedColor = habit.color ?? "#FFFFFF"
                    category = habit.category ?? "Good"
                    notificationsEnabled = habit.notificationsEnabled
                    var components = DateComponents()
                    components.hour = Int(habit.notificationHour)
                    components.minute = Int(habit.notificationMinute)
                    notificationTime = Calendar.current.date(from: components) ?? Date()
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
