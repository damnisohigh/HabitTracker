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
        let habitColor = Color(hex: habit.color ?? "#FFFFFF") // Default to white if nil
        
        // This VStack was the original top-level container for the row's content
        VStack(alignment: .leading, spacing: 8) { // Increased spacing a bit for clarity inside the card
            HStack(alignment: .top) {
                // Habit Color Indicator (Circle or other shape)
                Circle()
                    .fill(habitColor)
                    .frame(width: 20, height: 20)
                    .padding(.top, 2) // Align better with multiline text
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.title ?? NSLocalizedString("No Title", comment: "Placeholder for habit with no title"))
                        .font(.headline)
                    
                    if habit.category?.lowercased() == "bad", let lastReset = habit.lastResetDate {
                        let abstinenceLabel = NSLocalizedString("Abstinence: %@", comment: "Label for abstinence time, %@ is the time duration")
                        // Assuming timeSince function is working correctly now
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
                            .tint(habitColor) // Tint the progress bar with habit color
                    }
                }
                
                Spacer() // Pushes buttons to the right
                
                HStack(alignment: .center, spacing: 15) { // Main HStack for action buttons
                    Button(action: onEdit) {
                        Image(systemName: "pencil.circle.fill") // Changed to filled circle for better tap target
                            .foregroundColor(.blue)
                            .imageScale(.large) // Made pencil larger
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .contentShape(Rectangle())

                    if habit.category?.lowercased() == "bad", let reset = resetBadHabit {
                        Button(action: reset) {
                            Text(NSLocalizedString("Broke", comment: "Button text to reset a bad habit timer"))
                                .font(.footnote) // Slightly larger font
                                .fontWeight(.semibold)
                                .foregroundColor(.white) // White text
                                .padding(.horizontal, 10) // More horizontal padding
                                .padding(.vertical, 5)   // More vertical padding
                                .background(Color.red)    // Solid red background
                                .clipShape(Capsule())
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .contentShape(Rectangle())
                    } else {
                        Button(action: markAsCompleted) {
                            Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(habit.isCompleted ? .green : .gray)
                                .imageScale(.large) // Made checkmark larger (was .large, ensure it's effective)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .contentShape(Rectangle())
                    }
                }
            }
        }
        .contentShape(Rectangle()) // Makes the entire VStack area tappable
        .onTapGesture {
            if habit.details != nil && !(habit.details ?? "").isEmpty {
                onRowTap()
            }
        }
        .padding() // Internal padding for the card content
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.secondarySystemGroupedBackground) : Color(.systemBackground))
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 0) // Even closer to screen edges
        .padding(.vertical, 0)   // Closer to each other
        .onAppear {
            // Restart timer if view appears
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                // Only update if the view is still around (though for List rows this might be tricky)
                 now = Date()
            }
            // Note: Timers in list rows can be tricky. For a continuously updating timer,
            // it might be better to have a single source of truth for 'now' passed down,
            // or use the new TimelineView in SwiftUI if appropriate for the context.
            // For now, this will restart a timer each time the row appears.
        }
    }
}

#if os(iOS)
    // iOS
#elseif os(macOS)
    // macOS
#endif
