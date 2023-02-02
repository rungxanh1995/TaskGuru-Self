//
//  AddTaskViewModel.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

extension AddTask {
	final class ViewModel: ObservableObject {
		@Published var taskName: String = ""
		@Published var dueDate: Date = .now
		@Published var taskType: TaskType = .personal
		@Published var taskStatus: TaskStatus = .new
		@Published var taskNotes: String = ""
		
		private let listViewModel: HomeView.ViewModel
		
		init(parentVM: HomeView.ViewModel) {
			listViewModel = parentVM
		}
				
		func addTask(name: inout String, dueDate: Date, type: TaskType,
					 status: TaskStatus, notes: String) {
			assignDefaultTaskName(to: &name)
			listViewModel.addTask(name: &name, type: type, dueDate: dueDate, status: status, notes: notes)
		}
		
		fileprivate func assignDefaultTaskName(to name: inout String) {
			if name == "" { name = "Untitled Task" }
		}
	}
}
