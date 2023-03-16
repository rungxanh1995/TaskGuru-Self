//
//  TaskItem+CoreDataProperties.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 3/3/23.
//
//

import Foundation
import CoreData
import SwiftUI

extension TaskItem: Identifiable {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
		return NSFetchRequest<TaskItem>(entityName: "TaskItem")
	}

	// MARK: - Raw properties managed by Core Data
	// swiftlint:disable identifier_name
	@NSManaged private var cd_id: UUID?
	@NSManaged private var cd_name: String?
	@NSManaged private var cd_dueDate: Date?
	@NSManaged private var cd_lastUpdated: Date?
	@NSManaged private var cd_type: String?
	@NSManaged private var cd_status: String?
	@NSManaged public var cd_priority: String?
	@NSManaged private var cd_notes: String?

	// MARK: - Unwrapped properties
	public var id: UUID {
		get { cd_id ?? UUID() }
		set { cd_id = newValue }
	}
	var name: String {
		get { cd_name ?? "Untitled Task" }
		set {
			cd_name = newValue
			cd_lastUpdated = .now
		}
	}

	var dueDate: Date {
		get { cd_dueDate ?? .now }
		set {
			cd_dueDate = newValue
			cd_lastUpdated = .now
		}
	}

	var numericDueDate: String {
		dueDate.formatted(date: .numeric, time: .shortened)
	}

	var shortDueDate: String {
		dueDate.formatted(.dateTime.day().month())
	}

	var relativeDueDate: String {
		let formatter = RelativeDateTimeFormatter()
		formatter.dateTimeStyle = .named
		return formatter.localizedString(for: dueDate, relativeTo: .now).capitalizingFirstLetter()
	}

	var lastUpdated: Date {
		get { cd_lastUpdated ?? .now }
		set { cd_lastUpdated = newValue }
	}

	var formattedLastUpdated: String {
		lastUpdated.formatted(date: .numeric, time: .shortened)
	}

	var type: TaskType {
		get { TaskType(rawValue: cd_type ?? "Other") ?? .other }
		set {
			cd_type = newValue.rawValue
			cd_lastUpdated = .now
		}
	}

	var status: TaskStatus {
		get { TaskStatus(rawValue: cd_status ?? "New") ?? .new }
		set {
			cd_status = newValue.rawValue
			cd_lastUpdated = .now
		}
	}

	var priority: TaskPriority {
		get { TaskPriority(rawValue: cd_priority ?? "None") ?? .none }
		set {
			cd_priority = newValue.rawValue
			cd_lastUpdated = .now
		}
	}

	var isNotDone: Bool { status != .done }

	var notes: String {
		get { cd_notes ?? "" }
		set {
			cd_notes = newValue
			cd_lastUpdated = .now
		}
	}
}

extension TaskItem {
	func colorForStatus() -> Color {
		switch status {
		case .new: return Color.gray
		case .inProgress: return Color.appYellow
		case .done: return Color.appTeal
		}
	}

	/// Shows green when not approaching today's date, orange on today's date, and red when passed today's date
	func colorForDueDate() -> Color {
		if dueDate.isFromTomorrow {
			return Color.appTeal
		} else if dueDate.isWithinToday {
			return Color.appYellow
		} else {
			return Color.appPink
		}
	}

	func colorForPriority() -> Color {
		switch priority {
		case .none: return Color.gray
		case .low: return Color.appTeal
		case .medium: return Color.appYellow
		case .high: return Color.appPink
		}
	}
}
