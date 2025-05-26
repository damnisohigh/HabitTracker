//
//  SettingsViewModel.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 26.05.2025.
//

import SwiftUI
import Combine

// Определяем ключи для UserDefaults
enum SettingsKeys {
    static let appTheme = "appTheme"
    static let appLanguage = "appLanguage"
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

    init() {
        let savedThemeRaw = UserDefaults.standard.string(forKey: SettingsKeys.appTheme) ?? AppTheme.system.rawValue
        self.selectedTheme = AppTheme(rawValue: savedThemeRaw) ?? .system

        let savedLanguageRaw = UserDefaults.standard.string(forKey: SettingsKeys.appLanguage) ?? AppLanguage.english.rawValue
        self.selectedLanguage = AppLanguage(rawValue: savedLanguageRaw) ?? .english
        
        print("SettingsViewModel initialized. Theme: \(selectedTheme.rawValue), Language: \(selectedLanguage.rawValue)")
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
}
