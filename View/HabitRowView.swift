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
    
    var body: some View {
        let habitColor = Color(hex: habit.color ?? "#FFFFFF")
        
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top) {
                Circle()
                    .fill(habitColor)
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.title ?? "No Title")
                        .font(.headline)
                    
                    if habit.category?.lowercased() == "bad", let lastReset = habit.lastResetDate {
                        Text("⏱️Abstinence: \(timeSince(lastReset, now: now))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(habit.habitType ?? "Unknown")
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
                            Text("Broke")
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
