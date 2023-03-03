//
//  Constants.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

enum TaskConstants {
	static let dateRangeFromToday: PartialRangeFrom<Date> = Date()...
	static let allTypes: [TaskType] = TaskType.allCases
	static let allStatuses: [TaskStatus] = TaskStatus.allCases
}
