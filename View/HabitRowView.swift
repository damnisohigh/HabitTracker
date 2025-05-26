//
//  HabitRowView.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 14.04.2025.
//

import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    let markAsCompleted: () -> Void
    let resetBadHabit: (() -> Void)?
    let onEdit: () -> Void

    @State private var now = Date()
    // @Environment(\.locale) var locale: Locale
    
    var body: some View {
        let habitColor = Color(hex: habit.color ?? "#FFFFFF")
        
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top) {
                Circle()
                    .fill(habitColor)
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.title ?? NSLocalizedString("No Title", comment: "Placeholder for habit with no title"))
                        .font(.headline)
                    
                    if habit.category?.lowercased() == "bad", let lastReset = habit.lastResetDate {
                        let abstinenceLabel = NSLocalizedString("Abstinence: %@", comment: "Label for abstinence time, %@ is the time duration")
                        Text(String(format: abstinenceLabel, timeSince(lastReset, now: now, shortStyle: true)))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(NSLocalizedString(habit.habitType ?? "Unknown", comment: "Habit type (Daily, Weekly, etc.) or Unknown if not set"))
                        .font(.subheadline)
                        .foregroundColor((habit.category ?? "").lowercased() == "bad" ? .red : .green)
                    
                    if habit.goalCount > 0 {
                        ProgressView(value: Float(habit.currentCount), total: Float(habit.goalCount))
                            .progressViewStyle(LinearProgressViewStyle())
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Button(action: {
                        onEdit()
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(BorderlessButtonStyle()) 
                    .contentShape(Rectangle())

                    if habit.category?.lowercased() == "bad", let reset = resetBadHabit {
                        Button(action: reset) {
                            Text(NSLocalizedString("Broke", comment: "Button text to reset a bad habit timer"))
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .contentShape(Rectangle())
                    } else {
                        Button(action: markAsCompleted) {
                            Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(habit.isCompleted ? .green : .gray)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .contentShape(Rectangle())
                    }
                }
                .padding(.leading, 4)
            }
        }
        .padding(.vertical, 5)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                now = Date()
            }
        }
    }
}

#if os(iOS)
    // iOS
#elseif os(macOS)
    // macOS 
#endif
