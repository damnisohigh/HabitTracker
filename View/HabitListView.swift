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
                        let habitColor = Color(hex: habit.color ?? "#FFFFFF")
                        
                        HStack {
                            Circle()
                                .fill(habitColor)
                                .frame(width: 20, height: 20)
                            
                            VStack(alignment: .leading) {
                                Text(habit.title ?? "No Title")
                                    .font(.headline)
                                
                                Text(habit.habitType ?? "Unknown")
                                    .font(.subheadline)
                                    .foregroundColor((habit.category ?? "").lowercased() == "bad" ? .red : .green)
                                
                                if habit.goalCount > 0 {
                                    ProgressView(value: Float(habit.currentCount), total: Float(habit.goalCount))
                                        .progressViewStyle(LinearProgressViewStyle())
                                }
                            }
                            Spacer()
                            
                            Button(action: {
                                viewModel.markHabitAsCompleted(habit)
                            }) {
                                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(habit.isCompleted ? .green : .gray)
                                    .padding(.trailing, 10)
                            }
                            .buttonStyle(.plain)
                            .contentShape(Rectangle())
                        }
                        .padding(.vertical, 5)
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




