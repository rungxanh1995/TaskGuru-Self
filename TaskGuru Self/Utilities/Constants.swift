//
//  Constants.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

enum TaskConstants {
	static let dateRangeFromToday: PartialRangeFrom<Date> = Date()...
	static let allTypes: [TaskItem.TaskType] = TaskItem.TaskType.allCases
	static let allStatuses: [TaskItem.TaskStatus] = TaskItem.TaskStatus.allCases
}
