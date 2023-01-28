//
//  TaskItem.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

struct TaskItem: Codable, Identifiable, Hashable {
	var id: UUID = .init()
	
	var name: String {
		didSet { lastUpdated = .now }
	}
	
	var type: Self.TaskType
	
	var dueDate: Date {
		didSet { lastUpdated = .now }
	}
	
	var numericDueDate: String {
		dueDate.formatted(date: .numeric, time: .omitted)
	}
	
	var shortDueDate: String {
		dueDate.formatted(date: .abbreviated, time: .omitted)
	}
	
	var status: Self.TaskStatus {
		didSet { lastUpdated = .now }
	}
	
	var lastUpdated: Date = .now
	
	var formattedLastUpdated: String {
		lastUpdated.formatted(date: .numeric, time: .shortened)
	}
	
	var notes: String {
		didSet { lastUpdated = .now }
	}
}
