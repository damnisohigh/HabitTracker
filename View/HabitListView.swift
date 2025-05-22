//
//  HabitListView.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 27.03.2025.
//

import SwiftUI
import CoreData

struct HabitListView: View {
    
    @StateObject var viewModel: HabitListViewModel
    @State private var isShowingAddHabitView: Bool = false
    @State private var habitToEdit: Habit? = nil
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HabitListViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Type of habit", selection: $viewModel.currentFilter) {
                    ForEach(HabitListViewModel.HabitFilterType.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                Picker("Habit Frequency", selection: $viewModel.typeFilter) {
                    ForEach(HabitListViewModel.HabitTypeFilter.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                List {
                    ForEach(viewModel.filteredHabits) { habit in
                        HabitRowView(
                            habit: habit,
                            markAsCompleted: { viewModel.markHabitAsCompleted(habit) },
                            resetBadHabit: { viewModel.resetBadHabit(habit) },
                            onEdit: {
                                habitToEdit = habit
                                isShowingAddHabitView = true
                            }
                        )
                        .padding(.vertical, 8) // добавляем вертикальные отступы
                        .listRowSeparator(.hidden) // убираем разделители
                        .listRowBackground(Color.clear) // делаем фон строки прозрачным
                    }
                    .onDelete(perform: deleteHabit)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("HabitTracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingAddHabitView = true
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddHabitView, onDismiss: {
                habitToEdit = nil
            }) {
                HabitFormView(viewModel: viewModel, habitToEdit: habitToEdit)
            }
        }
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        offsets.forEach { index in
            let habit = viewModel.filteredHabits[index]
            viewModel.deleteHabit(habit)
        }
    }
}

#if os(iOS)
// iOS 
#elseif os(macOS)
// macOS
#endif




