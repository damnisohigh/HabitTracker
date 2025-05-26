//
//  StatisticsView.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 18.05.2025.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    var habits: [Habit]
    @StateObject private var viewModel = StatisticsViewModel()

    var body: some View {
        NavigationView {
            List {
                frequencySection
                badHabitsSection
                chartSection
            }
            .navigationTitle(NSLocalizedString("Statistics", comment: "Navigation title for statistics screen"))
            .onAppear {
                viewModel.update(with: habits)
            }
            .onChange(of: habits) { newHabits in
                viewModel.update(with: newHabits)
            }
        }
    }

    // MARK: - Sections

    private var frequencySection: some View {
        Section(header: Text(NSLocalizedString("By Frequency", comment: "Section header for statistics by frequency"))) {
            ForEach(StatisticsViewModel.HabitFrequency.allCases, id: \.self) { frequency in
                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString(frequency.rawValue.capitalized, comment: "Frequency type name"))
                        .font(.headline)
                    
                    let key = StatisticsViewModel.StatKey.frequency(frequency)
                    let stat = viewModel.stats[key] ?? (0, 0, 0.0)
                    let format = NSLocalizedString("StatsFormat_Total_Completed_Rate", comment: "Format: Total, Completed, Rate")
                    Text(String(format: format, stat.0, stat.1, Int(stat.2 * 100)))
                    
                    Text("\(NSLocalizedString(createdKeyText(forLocalizable: frequency), comment: "Created habits count label")): \(viewModel.createdHabitsCountByFrequency[frequency] ?? 0)")
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    private func createdKeyText(forLocalizable frequency: StatisticsViewModel.HabitFrequency) -> String {
        switch frequency {
        case .daily: return "Created today"
        case .weekly: return "Created this week"
        case .monthly: return "Created this month"
        }
    }

    private var badHabitsSection: some View {
        Section(header: Text(NSLocalizedString("Bad Habits Insights", comment: "Section header for bad habits statistics"))) {
            if let stats = viewModel.badHabitStats {
                let longest = viewModel.formattedDuration(from: stats.longestStreak)
                let average = viewModel.formattedDuration(from: stats.averageStreak)
                Text(String(format: NSLocalizedString("Longest Abstinence: %@", comment: "Longest abstinence display format"), longest))
                Text(String(format: NSLocalizedString("Average Abstinence: %@", comment: "Average abstinence display format"), average))
            } else {
                Text(NSLocalizedString("No bad habit data yet or no recorded abstinence periods.", comment: "Placeholder for no bad habit stats"))
            }
        }
    }

    private var chartSection: some View {
        Section(header: Text(NSLocalizedString("Completion Rate Chart", comment: "Section header for completion rate chart"))) {
            ChartView(stats: viewModel.stats)
                .frame(height: 300)
                .listRowInsets(EdgeInsets())
        }
    }
}
