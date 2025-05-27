import SwiftUI

struct HabitDetailView: View {
    @Environment(\.dismiss) var dismiss
    let habit: Habit
    
    @State private var isShowingEditView = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(habit.title ?? NSLocalizedString("No Title", comment: "Placeholder for habit with no title"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)

                    if let details = habit.details, !details.isEmpty {
                        Text(NSLocalizedString("Details", comment: "Section header for habit details"))
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(details)
                            .font(.body)
                            .padding(.bottom, 8)
                    } else {
                        Text(NSLocalizedString("No details provided.", comment: "Placeholder for no habit details"))
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.bottom, 8)
                    }

                    // Можно добавить другую информацию о привычке:
                    HStack {
                        Text(NSLocalizedString("Type:", comment: "Label for habit type"))
                            .fontWeight(.semibold)
                        Text(NSLocalizedString(habit.habitType ?? "Unknown", comment: "Habit type value"))
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Category:", comment: "Label for habit category"))
                            .fontWeight(.semibold)
                        Text(NSLocalizedString(habit.category ?? "Unknown", comment: "Habit category value"))
                    }

                    if habit.goalCount > 0 {
                        HStack {
                            Text(NSLocalizedString("Goal:", comment: "Label for habit goal"))
                                .fontWeight(.semibold)
                            Text("\(habit.currentCount) / \(habit.goalCount)")
                        }
                    }
                    
                    if let createdAt = habit.createdAt {
                        HStack {
                            Text(NSLocalizedString("Created:", comment: "Label for habit creation date"))
                                .fontWeight(.semibold)
                            Text(createdAt, style: .date)
                        }
                    }
                    
                    // Добавить кнопку "Редактировать"
                    // Для этого нам понадобится доступ к HabitListViewModel
                    // или передавать замыкание для редактирования.
                    // Пока пропустим кнопку редактирования из этого View для упрощения.

                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("Habit Details", comment: "Navigation title for habit detail screen"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Done", comment: "Done button label")) {
                        dismiss()
                    }
                }
            }
        }
    }
}

