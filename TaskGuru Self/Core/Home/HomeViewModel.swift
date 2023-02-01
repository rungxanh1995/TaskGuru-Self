//
//  HomeViewModel.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

extension HomeView {
	final class ViewModel: ObservableObject {
		@Published
		private(set) var allTasks: [TaskItem] = .init()
		
		@Published
		var isShowingAddTaskView: Bool = false
		
		// MARK: - CRUD Operations
		
		// ADD
		
		func addTask(name: inout String, type: TaskType, dueDate: Date,
					 status: TaskStatus, notes: String) -> Void {
			assignDefaultTaskName(to: &name)
			
			let newItem = TaskItem(name: name, dueDate: dueDate, lastUpdated: .now, type: type, status: status, notes: notes)
			addTask(newItem)
		}
		
		fileprivate func addTask(_ newItem: TaskItem) -> Void {
			allTasks.append(newItem)
		}
		
		fileprivate func assignDefaultTaskName(to name: inout String) -> Void {
			if name == "" { name = "Untitled Task" }
		}
		
		// UPDATE
		
		func updateTasks(with item: TaskItem) -> Void {
			guard let index = getIndex(of: item) else { return }
			allTasks[index] = item
		}
		
		fileprivate func getIndex(of item: TaskItem) -> Int? {
			return allTasks.firstIndex { $0.id == item.id }
		}
		
		// DELETE
		func deletePersonalTasks(at offsets: IndexSet) -> Void {
			allTasks.remove(atOffsets: offsets)
		}
	}
}
