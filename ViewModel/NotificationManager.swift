import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func scheduleNotification(habitId: String, title: String, body: String, hour: Int, minute: Int, weekday: Int? = nil, day: Int? = nil, repeats: Bool) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        if let weekday {
            dateComponents.weekday = weekday // 1 = Sunday, 2 = Monday, ..., 7 = Saturday
        }
        if let day {
            dateComponents.day = day 
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let request = UNNotificationRequest(identifier: habitId, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                var logMessage = "Notification scheduled for \(title) at \(hour):\(String(format: "%02d", minute))"
                if let weekday = dateComponents.weekday { logMessage += " on weekday \(weekday)" }
                if let day = dateComponents.day { logMessage += " on day \(day) of month" }
                if repeats { logMessage += " (repeats)" } else { logMessage += " (does not repeat)" }
                print(logMessage)
            }
        }
    }

    func cancelNotification(habitId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habitId])
        print("Cancelled notification for habit ID: \(habitId)")
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All pending notifications have been cancelled.")
    }
    
    func checkNotificationStatus(for habitId: String, completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let scheduled = requests.contains { $0.identifier == habitId }
            DispatchQueue.main.async {
                completion(scheduled)
            }
        }
    }
}
