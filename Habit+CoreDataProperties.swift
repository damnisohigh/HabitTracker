//
//  Habit+CoreDataProperties.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 27.05.2025.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var abstinencePeriodsCount: Int64
    @NSManaged public var category: String?
    @NSManaged public var color: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var currentCount: Int16
    @NSManaged public var details: String?
    @NSManaged public var goalCount: Int16
    @NSManaged public var habitType: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var lastCompletedDate: Date?
    @NSManaged public var lastResetDate: Date?
    @NSManaged public var longestAbstinenceDuration: Double
    @NSManaged public var title: String?
    @NSManaged public var totalAbstinenceDuration: Double
    @NSManaged public var notificationsEnabled: Bool
    @NSManaged public var notificationHour: Int16
    @NSManaged public var notificationMinute: Int16

}

extension Habit : Identifiable {

}
