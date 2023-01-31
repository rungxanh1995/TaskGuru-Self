//
//  TaskEntityConverter.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-30.
//

import Foundation

enum TaskEntityConverter {
	
	/// Converts a Core Data `CachedTask` instance to user-friendly `TaskItem` instance
	static func convertToTaskItem(from cachedTask: CachedTask) -> TaskItem {
		let taskItem = TaskItem(
			name: cachedTask.name,
			type: cachedTask.type,
			dueDate: cachedTask.dueDate,
			status: cachedTask.status,
			lastUpdated: cachedTask.lastUpdated,
			notes: cachedTask.notes)
		return taskItem
	}
}
