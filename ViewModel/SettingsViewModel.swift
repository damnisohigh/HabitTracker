//
//  SettingsViewModel.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 26.05.2025.
//

import SwiftUI
import Combine
import UserNotifications

// Определяем ключи для UserDefaults
enum SettingsKeys {
    static let appTheme = "appTheme"
    static let appLanguage = "appLanguage"
    static let globalNotificationsEnabled = "globalNotificationsEnabled"
}

// Возможные варианты темы
enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { self.rawValue }
}

// Возможные варианты языка
enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "English"
    case ukrainian = "Ukrainian"

    var id: String { self.rawValue }
    
    var localeIdentifier: String {
        switch self {
        case .english: return "en"
        case .ukrainian: return "uk"
        }
    }
}

class SettingsViewModel: ObservableObject {
    @Published var selectedTheme: AppTheme {
        didSet {
            saveTheme()
        }
    }
    @Published var selectedLanguage: AppLanguage {
        didSet {
            saveLanguage()
            // Это изменит язык приложения после перезапуска
            UserDefaults.standard.set([selectedLanguage.localeIdentifier], forKey: "AppleLanguages")
            print("AppleLanguages set to: [\(selectedLanguage.localeIdentifier)]. App restart might be needed for full effect.")
        }
    }
    @Published var globalNotificationsEnabled: Bool {
        didSet {
            saveGlobalNotificationsSetting()
            if !globalNotificationsEnabled {
                NotificationManager.shared.cancelAllNotifications()
                print("All pending notifications cancelled due to global setting.")
            }
            // If globally enabled, existing per-habit notifications are NOT automatically rescheduled here.
            // This would require iterating through all habits and calling scheduleOrCancelNotification.
            // For simplicity, we'll let them be rescheduled individually or upon app restart/habit reset.
        }
    }

    init() {
        let savedThemeRaw = UserDefaults.standard.string(forKey: SettingsKeys.appTheme) ?? AppTheme.system.rawValue
        self.selectedTheme = AppTheme(rawValue: savedThemeRaw) ?? .system

        let savedLanguageRaw = UserDefaults.standard.string(forKey: SettingsKeys.appLanguage) ?? AppLanguage.english.rawValue
        self.selectedLanguage = AppLanguage(rawValue: savedLanguageRaw) ?? .english
        
        self.globalNotificationsEnabled = UserDefaults.standard.object(forKey: SettingsKeys.globalNotificationsEnabled) as? Bool ?? true
        
        print("SettingsViewModel initialized. Theme: \(selectedTheme.rawValue), Language: \(selectedLanguage.rawValue), Global Notifications: \(globalNotificationsEnabled)")
    }

    // Функции для сохранения, если решим не использовать didSet
    func saveTheme() {
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: SettingsKeys.appTheme)
        print("Theme saved: \(selectedTheme.rawValue)")
        // Здесь может быть логика немедленного применения темы
    }

    func saveLanguage() {
        UserDefaults.standard.set(selectedLanguage.rawValue, forKey: SettingsKeys.appLanguage)
        print("Language saved: \(selectedLanguage.rawValue)")
        // Здесь может быть логика немедленного применения языка
    }
    
    func saveGlobalNotificationsSetting() {
        UserDefaults.standard.set(globalNotificationsEnabled, forKey: SettingsKeys.globalNotificationsEnabled)
        print("Global notification setting saved: \(globalNotificationsEnabled)")
    }
}
