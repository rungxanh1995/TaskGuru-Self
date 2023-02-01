//
//  TaskItem.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-31.
//

import SwiftUI

struct TaskItem {
	var id: UUID = UUID()
	
	var name: String {
		didSet { lastUpdated = .now }
	}
	
	var dueDate: Date  {
		didSet { lastUpdated = .now }
	}
	
	var numericDueDate: String {
		dueDate.formatted(date: .numeric, time: .omitted)
	}
	
	var shortDueDate: String {
		dueDate.formatted(date: .abbreviated, time: .omitted)
	}
	
	var lastUpdated: Date
	
	var formattedLastUpdated: String {
		lastUpdated.formatted(date: .numeric, time: .shortened)
	}
	
	var type: TaskType  {
		didSet { lastUpdated = .now }
	}
	
	var status: TaskStatus  {
		didSet { lastUpdated = .now }
	}
	
	var notes: String  {
		didSet { lastUpdated = .now }
	}
}

extension TaskItem {
	static let mockData: [TaskItem] = [
		TaskItem(name: "Buy vacation ticket 🎟️", dueDate: Date(timeIntervalSinceNow: 60*60*24*135),
				 lastUpdated: .now, type: .personal, status: .inProgress, notes: "Look for affordable options"),
		TaskItem(name: "Design document 🎨", dueDate: Date(timeIntervalSinceNow: 60*60*24*15),
				 lastUpdated: .now, type: .school, status: .done,
				 notes: "A prototype of the GUI for app with mock data/hardcoded info done in Xcode"),
		TaskItem(name: "Early prototype 📱", dueDate: Date(timeIntervalSinceNow: 60*60*24*45), lastUpdated: .now,
				 type: .school, status: .new,
				 notes: "Implementation of one of the screens described in the proposal document."),
		TaskItem(name: "Final implementation", dueDate: Date(timeIntervalSinceNow: 60*60*24*90), lastUpdated: .now,
				 type: .school, status: .new, notes: "")
	]
}
