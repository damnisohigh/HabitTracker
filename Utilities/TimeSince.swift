//
//  TimeSince.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 14.04.2025.
//

import Foundation

func timeSince(_ date: Date, now: Date = Date(), shortStyle: Bool = false) -> String {
    let interval = now.timeIntervalSince(date)

    if interval <= 0 {
        // Для простоты и чтобы избежать NSLocalizedString пока проблема не решена
        return shortStyle ? "0s" : "0 seconds" 
    }

    let formatter = DateComponentsFormatter()
    // НЕ УСТАНАВЛИВАЕМ formatter.locale, чтобы избежать ошибки компиляции
    // Он будет использовать системную локаль по умолчанию.
    
    formatter.allowedUnits = [.day, .hour, .minute, .second]
    formatter.unitsStyle = shortStyle ? .abbreviated : .full 
    formatter.maximumUnitCount = shortStyle ? 2 : 2 // Можно настроить по-разному для short и full

    // Дополнительная логика для shortStyle, чтобы сделать его более компактным, как в твоей оригинальной функции
    if shortStyle {
        if interval >= 86400 { // Больше или равно дню
            formatter.allowedUnits = [.day, .hour]
        } else if interval >= 3600 { // Больше или равно часу
            formatter.allowedUnits = [.hour, .minute]
        } else if interval >= 60 { // Больше или равно минуте
            formatter.allowedUnits = [.minute, .second]
        } else { // Секунды
            formatter.allowedUnits = [.second]
            formatter.maximumUnitCount = 1 // Только секунды, без "0м"
        }
    }
    
    if let formattedString = formatter.string(from: interval) {
        return formattedString
    } else {
        return "Error formatting time"
    }
}
 

#if os(iOS)
    // iOS 
#elseif os(macOS)
    // macOS
#endif
