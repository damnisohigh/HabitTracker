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
    // Ключ должен совпадать с тем, что используется в SettingsViewModel (SettingsKeys.appTheme)
    @AppStorage(SettingsKeys.appTheme) var currentThemeRaw: String = AppTheme.system.rawValue

    private var preferredColorScheme: ColorScheme? {
        switch AppTheme(rawValue: currentThemeRaw) {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system, .none: // .none на случай, если rawValue не распознан
            return nil // nil означает системную тему
        }
    }
    
    init() {
        if let savedLanguageCode = UserDefaults.standard.string(forKey: SettingsKeys.appLanguage),
           let appLanguage = AppLanguage(rawValue: savedLanguageCode) {
            print("Setting preferred language to: \(appLanguage.localeIdentifier)")
            UserDefaults.standard.set([appLanguage.localeIdentifier], forKey: "AppleLanguages")
            // UserDefaults.standard.synchronize() // synchronize() больше не нужен в современных iOS
        }
        NotificationManager.shared.requestAuthorization { granted in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabBarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(preferredColorScheme)
        }
    }
}

#if os(iOS)
    // iOS
#elseif os(macOS)
    // macOS
#endif
