//
//  TaskType.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

enum TaskType: String, Codable, CaseIterable {
	case personal = "taskItem.type.personal"
	case work = "taskItem.type.work"
	case school = "taskItem.type.school"
	case coding = "taskItem.type.coding"
	case other = "taskItem.type.other"
}
