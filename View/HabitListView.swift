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
                
                List {
                    ForEach(viewModel.filteredHabits) { habit in
                        HabitRowView(
                            habit: habit,
                            markAsCompleted: { viewModel.markHabitAsCompleted(habit) },
                            resetBadHabit: { viewModel.resetBadHabit(habit) }
                        )
                    }
                    .onDelete(perform: deleteHabit)
                }
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
            .sheet(isPresented: $isShowingAddHabitView) {
                AddHabitView(viewModel: viewModel)
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





