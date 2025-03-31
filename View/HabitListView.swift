//
//  HabitListView.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 27.03.2025.
//

import SwiftUI
import CoreData

struct HabitListView: View {
    
    @StateObject var viewModel: HabitListViewModlel
    @State private var isShowingAddHabitView: Bool = false
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HabitListViewModlel(context: context))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.habits) { habit in
                    HStack {
                        Circle()
                            .fill(Color(hex: habit.color ?? "#FFFFFF"))
                            .frame(width: 20, height: 20)
                        
                        VStack(alignment: .leading) {
                            Text(habit.title ?? "No Title")
                                .font(.headline)
                            
                            Text(habit.habitType ?? "Unknown Type")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            // Проверяем, есть ли цель
                            if habit.goalCount > 0 {
                                ProgressView(value: Float(habit.currentCount), total: Float(habit.goalCount))
                                    .progressViewStyle(LinearProgressViewStyle())
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
                .onDelete(perform: deleteHabit)
            }
            .navigationTitle("Habits")
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
            let habit = viewModel.habits[index]
            viewModel.deleteHabit(habit)
        }
    }
}



