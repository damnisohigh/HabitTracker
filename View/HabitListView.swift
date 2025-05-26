//
//  HabitListView.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 27.03.2025.
//

import SwiftUI
import CoreData

struct HabitListView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: HabitListViewModel
    @State private var isShowingAddHabitView = false
    @State private var habitToEdit: Habit? = nil
    @State private var selectedHabitForDetail: Habit? = nil

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HabitListViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker(NSLocalizedString("Filter", comment: "Picker label for habit category filter"), selection: $viewModel.currentFilter) {
                    ForEach(HabitListViewModel.HabitFilterType.allCases, id: \.self) { filter in
                        Text(NSLocalizedString(filter.rawValue, comment: "Habit filter type raw value")).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                Picker(NSLocalizedString("Habit Frequency", comment: "Picker label for habit frequency filter"), selection: $viewModel.typeFilter) {
                    ForEach(HabitListViewModel.HabitTypeFilter.allCases, id: \.self) { type in
                        Text(NSLocalizedString(type.rawValue, comment: "Habit type filter raw value")).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                if viewModel.filteredHabits.isEmpty {
                    Spacer() // Pushes content to the center
                    VStack(spacing: 16) {
                        Image(systemName: "figure.mind.and.body") // Example icon
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("No habits yet!", comment: "Placeholder text when no habits are present"))
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("Tap the '+' button to add your first habit.", comment: "Instruction to add a new habit"))
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    Spacer() // Pushes content to the center
                } else {
                    List {
                        ForEach(viewModel.filteredHabits) { habit in
                            HabitRowView(
                                habit: habit,
                                markAsCompleted: { viewModel.markHabitAsCompleted(habit) },
                                resetBadHabit: { viewModel.resetBadHabit(habit) },
                                onEdit: {
                                    habitToEdit = habit
                                    isShowingAddHabitView = true
                                },
                                onRowTap: {
                                    // Only navigate if details exist (though HabitRowView also checks this)
                                    if habit.details != nil && !(habit.details ?? "").isEmpty {
                                        // Set selectedHabitForDetail to show detail view
                                        selectedHabitForDetail = habit
                                    }
                                }
                            )
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteHabit)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle(NSLocalizedString("HabitTracker", comment: "App name / main screen title"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingAddHabitView = true
                    }) {
                        Label(NSLocalizedString("Add", comment: "Add button label"), systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddHabitView, onDismiss: {
                habitToEdit = nil
            }) {
                HabitFormView(viewModel: viewModel, habitToEdit: habitToEdit)
            }
            .sheet(item: $selectedHabitForDetail) { habit in
                HabitDetailView(habit: habit)
            }
        }
        .onAppear {
            viewModel.fetchHabits()
        }
    }

    private func deleteHabit(offsets: IndexSet) {
        withAnimation {
            offsets.map { viewModel.filteredHabits[$0] }.forEach(viewModel.deleteHabit)
        }
    }
}

#if os(iOS)
// iOS
#elseif os(macOS)
// macOS
#endif
