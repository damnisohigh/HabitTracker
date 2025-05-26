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
                        .padding(.vertical, 8)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear) 
                    }
                    .onDelete(perform: deleteHabit)
                }
                .listStyle(PlainListStyle())
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
