//
//  ChartView.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 25.05.2025.
//

import Charts
import SwiftUI

struct ChartView: View {
    let stats: [StatisticsViewModel.StatKey: (Int, Int, Double)]

    private var kindCompletionData: [(kind: StatisticsViewModel.HabitKind, rate: Double)] {
        if let goodStat = stats[.kind(.good)] {
            return [(.good, goodStat.2)]
        } else {
            return [(.good, 0.0)]
        }
    }

    @State private var animateChart = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Good Habits Completion Rate")
                .font(.title2.bold())
                .padding(.leading)

            Chart {
                ForEach(kindCompletionData, id: \.kind) { item in
                    BarMark(
                        x: .value("Kind", item.kind.rawValue.capitalized),
                        y: .value("Completion Rate", animateChart ? item.rate * 100 : 0)
                    )
                    .foregroundStyle(colorForKind(item.kind).gradient)
                    .cornerRadius(5)
                    .annotation(position: .top) {
                        Text(String(format: "%.0f%%", item.rate * 100))
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 250)
            .padding(.horizontal)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                animateChart = true
            }
        }
    }

    private func colorForKind(_ kind: StatisticsViewModel.HabitKind) -> Color {
        switch kind {
        case .good:
            return .green
        case .bad: 
            return .red 
        }
    }
}
