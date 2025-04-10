//
//  Habit+CoreDataProperties.swift
//  HabitTracker
//
//  Created by DAMNISOHIGH on 04.04.2025.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var color: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var currentCount: Int16
    @NSManaged public var details: String?
    @NSManaged public var goalCount: Int16
    @NSManaged public var habitType: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var lastCompletedDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var category: String?

}

extension Habit : Identifiable {

}
