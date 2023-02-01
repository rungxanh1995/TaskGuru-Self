//
//  TaskType.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-31.
//

import Foundation

enum TaskType: String, Codable, CaseIterable {
	case personal = "Personal"
	case work = "Work"
	case school = "School"
	case other = "Other"
}
