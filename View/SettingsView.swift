//
//  SettingsView.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 18.05.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Appearance", comment: "Section header for appearance settings"))) {
                    Picker(NSLocalizedString("Theme", comment: "Theme picker label"), selection: $viewModel.selectedTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(NSLocalizedString(theme.rawValue, comment: "Theme option name")).tag(theme)
                        }
                    }
                }

                Section(header: Text(NSLocalizedString("Language", comment: "Section header for language settings"))) {
                    Picker(NSLocalizedString("Language", comment: "Language picker label"), selection: $viewModel.selectedLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(NSLocalizedString(language.rawValue, comment: "Language option name")).tag(language)
                        }
                    }
                    Text(NSLocalizedString("Changing the language may require an app restart to take full effect.", comment: "Restart warning for language change"))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Section(header: Text(NSLocalizedString("Notifications", comment: "Section header for notification settings"))) {
                    Toggle(NSLocalizedString("Enable All Notifications", comment: "Toggle label for enabling/disabling all notifications"), isOn: $viewModel.globalNotificationsEnabled)
                }
                
                Section(header: Text(NSLocalizedString("About", comment: "Section header for app information"))) {
                    HStack {
                        Text(NSLocalizedString("Version", comment: "Label for app version"))
                        Spacer()
                        Text("\(viewModel.appVersion) (\(viewModel.buildVersion))")
                            .foregroundColor(.gray)
                    }
                }
                
                // Можно добавить другие секции настроек здесь
            }
            .navigationTitle(NSLocalizedString("Settings", comment: "Navigation title for settings screen"))
        }
    }
}

#Preview {
    SettingsView()
}
