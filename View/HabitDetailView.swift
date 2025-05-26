import SwiftUI

struct HabitDetailView: View {
    @Environment(\.dismiss) var dismiss
    let habit: Habit
    
    // State для показа HabitFormView в режиме редактирования
    @State private var isShowingEditView = false
    // Нужен доступ к HabitListViewModel, чтобы передать его в HabitFormView
    // Это немного усложняет, если HabitDetailView вызывается из контекста, где нет ViewModel.
    // Пока оставим это так, возможно, понадобится EnvironmentObject.
    // Для простоты, пока не будем передавать viewModel, а просто покажем детали.
    // Редактирование можно будет добавить как следующий шаг.

    var body: some View {
        NavigationView { // Обертка для NavigationBar с кнопкой "Edit" и заголовком
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
                // Если решим добавить кнопку Edit здесь:
                // ToolbarItem(placement: .navigationBarTrailing) {
                //     Button(NSLocalizedString("Edit", comment: "Edit button label")) {
                //         // isShowingEditView = true // Это потребует .sheet(isPresented: $isShowingEditView)
                //     }
                // }
            }
        }
        // Если кнопка Edit будет в toolbar, и мы хотим показать HabitFormView модально:
        // .sheet(isPresented: $isShowingEditView) {
        //     // HabitFormView(viewModel: /* нужен viewModel */, habitToEdit: habit)
        // }
    }
}

// Добавим ключи локализации
