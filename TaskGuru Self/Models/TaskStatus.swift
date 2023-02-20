//
//  TaskStatus.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

enum TaskStatus: String, Codable, CaseIterable {
	case new = "taskItem.status.new"
	case inProgress = "taskItem.status.inProgress"
	case done = "taskItem.status.done"
}
