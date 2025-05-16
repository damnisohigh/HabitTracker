//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 23.03.2025.
//

import SwiftUI

@main
struct MyApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HabitListView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


#if os(iOS)
    // iOS специфичный код
#elseif os(macOS)
    // macOS специфичный код
#endif
