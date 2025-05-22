//
//  StatisticsView.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 18.05.2025.
//

import SwiftUI

struct StatisticsView: View {
    
    @ObservedObject var viewModel: StatisticsViewModel
    
    var body: some View {
        List {
            ForEach([StatisticsViewModel.HabitType.daily, .weekly, .monthly], id: \.self) { type in
                Section(header: Text(type.rawValue.capitalized)) {
                    Text("Total: \(viewModel.totalCount(for: type))")
                    Text("Completed: \(viewModel.completedCount(for: type))")
                    Text("Completion rate: \(viewModel.completionRate(for: type) * 100, specifier: "%.2f")%")
                }
            }
        }
    }
}


