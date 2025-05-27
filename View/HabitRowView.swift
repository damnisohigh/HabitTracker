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
    let onRowTap: () -> Void

    @State private var now = Date()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let habitColor = Color(hex: habit.color ?? "#FFFFFF") 
 
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Circle()
                    .fill(habitColor)
                    .frame(width: 20, height: 20)
                    .padding(.top, 2)
                
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
                            .tint(habitColor)
                    }
                }
                
                Spacer()
                
                HStack(alignment: .center, spacing: 15) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .contentShape(Rectangle())

                    if habit.category?.lowercased() == "bad", let reset = resetBadHabit {
                        Button(action: reset) {
                            Text(NSLocalizedString("Broke", comment: "Button text to reset a bad habit timer"))
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.red)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .contentShape(Rectangle())
                    } else {
                        Button(action: markAsCompleted) {
                            Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(habit.isCompleted ? .green : .gray)
                                .imageScale(.large)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .contentShape(Rectangle())
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if habit.details != nil && !(habit.details ?? "").isEmpty {
                onRowTap()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.secondarySystemGroupedBackground) : Color(.systemBackground))
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 0)
        .padding(.vertical, 0)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
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
