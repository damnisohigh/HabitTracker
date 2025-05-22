//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 23.03.2025.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabBarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

#if os(iOS)
    // iOS
#elseif os(macOS)
    // macOS
#endif
