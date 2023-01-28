//
//  TaskType.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

extension TaskItem {
	internal enum TaskType: String, Codable, CaseIterable {
		case personal = "Personal"
		case work = "Work"
		case school = "School"
		case other = "Other"
	}
}
