//
//  CachedTask+CoreDataProperties.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-30.
//
//	Refer to this tutorial for saving enum to Core Data
//	https://nemecek.be/blog/93/how-to-save-enum-to-core-data

import Foundation
import CoreData

extension CachedTask {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<CachedTask> {
		return NSFetchRequest<CachedTask>(entityName: "CachedTask")
	}

	@NSManaged public var cd_id: UUID?
	@NSManaged public var cd_name: String?
	@NSManaged public var cd_dueDate: Date?
	@NSManaged public var cd_type: String?
	@NSManaged public var cd_status: String?
	@NSManaged public var cd_lastUpdated: Date?
	@NSManaged public var cd_notes: String?
		
	// MARK: - Unwrapped properties
	 
	var name: String { cd_name ?? "Untitled Task" }
	var dueDate: Date { cd_dueDate ?? Date.now }
	var lastUpdated: Date { cd_lastUpdated ?? Date.now }
	var notes: String { cd_notes ?? "" }
	var type: TaskItem.TaskType {
		get { return TaskItem.TaskType(rawValue: cd_type ?? "Other") ?? .other }
		set { cd_type = newValue.rawValue }
	}

	var status: TaskItem.TaskStatus {
		get { return TaskItem.TaskStatus(rawValue: cd_type ?? "New") ?? .new }
		set { cd_status = newValue.rawValue }
	}
}

extension CachedTask: Identifiable {
	public var id: UUID { cd_id ?? UUID() }
}
