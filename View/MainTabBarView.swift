//
//  MainTabBarView.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 18.05.2025.
//

import SwiftUI

struct MainTabBarView: View {
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(
            entity: Habit.entity(),
            sortDescriptors: []
        ) private var habits: FetchedResults<Habit>
    
    
    var body: some View {
        TabView {
            HabitListView(context: context)
                .tabItem {
                    Label("Habits", systemImage: "checkmark.circle")
                }
            StatisticsView(viewModel: StatisticsViewModel(habits: Array(habits)))
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    MainTabBarView()
}
