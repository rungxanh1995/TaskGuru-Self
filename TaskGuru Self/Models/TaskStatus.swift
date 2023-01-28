//
//  TaskStatus.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

extension TaskItem {
	internal enum TaskStatus: String, Codable, CaseIterable {
		case new = "New"
		case inProgress = "In progress"
		case done = "Done"
	}
}
