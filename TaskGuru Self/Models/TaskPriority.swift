//
//  TaskPriority.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 3/3/23.
//

import Foundation

enum TaskPriority: String, Codable, CaseIterable {
	case none = "taskItem.priority.none"
	case low = "taskItem.priority.low"
	case medium = "taskItem.priority.medium"
	case high = "taskItem.priority.high"
}
