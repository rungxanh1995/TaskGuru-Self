//
//  DetailViewModel.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

extension DetailView {
	final class ViewModel: ObservableObject {
		var task: TaskItem
		
		// MARK: - Edit Mode
		@Published var taskName: String
		@Published var taskDueDate: Date
		@Published var taskType: TaskType
		@Published var taskStatus: TaskStatus
		@Published var taskNotes: String
		
		let parentVM: HomeView.ViewModel
		private let storageProvider: StorageProvider
		
		init(for task: TaskItem, parentVM: HomeView.ViewModel,
			 storageProvider: StorageProvider = StorageProviderImpl.standard) {
			self.task = task
			self.parentVM = parentVM
			self.storageProvider = storageProvider
			
			taskName = task.name
			taskDueDate = task.dueDate
			taskType = task.type
			taskStatus = task.status
			taskNotes = task.notes
		}
		
		var taskIsNewOrInProgress: Bool {
			return task.status == .new || task.status == .inProgress
		}
		
		func updateTask() {
			task.name = taskName
			task.dueDate = taskDueDate
			task.type = taskType
			task.status = taskStatus
			task.notes = taskNotes
			saveThenRefetchData()
		}
		
		func deleteTask() {
			storageProvider.context.delete(task)
			saveThenRefetchData()
		}
		
		func saveThenRefetchData() {
			storageProvider.saveAndHandleError()
			parentVM.fetchTasks()
		}
		
		func markTaskAsDone() {
			task.status = .done
			saveThenRefetchData()
		}
	}
}
