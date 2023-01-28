//
//  AddTaskViewModel.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

extension AddTask {
	final class ViewModel: ObservableObject {
		private let listViewModel: HomeView.ViewModel
		
		init(parentVM: HomeView.ViewModel) {
			listViewModel = parentVM
		}
		
		@Published
		var taskName: String = ""
		
		@Published
		var dueDate: Date = .now
		
		@Published
		var taskType: TaskItem.TaskType = .personal
		
		@Published
		var taskStatus: TaskItem.TaskStatus = .new
		
		@Published
		var taskNotes: String = ""
				
		func addTask(name: inout String, dueDate: Date, type: TaskItem.TaskType,
					 status: TaskItem.TaskStatus, notes: String) -> Void {
			listViewModel.addTask(name: &name, type: type, dueDate: dueDate, status: status, notes: notes)
		}
	}
}
