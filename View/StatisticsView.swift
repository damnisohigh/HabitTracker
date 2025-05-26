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
    @Environment(\.colorScheme) var colorScheme

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
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: iconName(for: frequency))
                            .font(.title2)
                            .foregroundColor(colorForFrequency(frequency))
                        Text(NSLocalizedString(frequency.rawValue.capitalized, comment: "Frequency type name"))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    let key = StatisticsViewModel.StatKey.frequency(frequency)
                    let stat = viewModel.stats[key] ?? (0, 0, 0.0)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("Total:", comment: "Label for total habits in stats"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(stat.0)")
                                .font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("Completed:", comment: "Label for completed habits in stats"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(stat.1)")
                                .font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("Rate:", comment: "Label for completion rate in stats"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(Int(stat.2 * 100))%")
                                .font(.headline)
                        }
                    }
                    .padding(.top, 4)

                    Divider()

                    Text("\(NSLocalizedString(createdKeyText(forLocalizable: frequency), comment: "Created habits count label")): \(viewModel.createdHabitsCountByFrequency[frequency] ?? 0)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? Color(.secondarySystemGroupedBackground) : Color(.systemBackground))
                        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.05), radius: 4, x: 0, y: 2)
                )
                .listRowInsets(EdgeInsets())
                .padding(.bottom,   16)
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

    private func iconName(for frequency: StatisticsViewModel.HabitFrequency) -> String {
        switch frequency {
        case .daily: return "sun.max.fill"
        case .weekly: return "arrow.7.circlepath"
        case .monthly: return "calendar"
        }
    }

    private func colorForFrequency(_ frequency: StatisticsViewModel.HabitFrequency) -> Color {
        switch frequency {
        case .daily: return .orange
        case .weekly: return .blue
        case .monthly: return .purple
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
