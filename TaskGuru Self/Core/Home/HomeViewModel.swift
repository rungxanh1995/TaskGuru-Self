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
		var searchText = ""
		
		var searchResults: [TaskItem] {
			if searchText.isEmpty {
				return allTasks
			} else {
				return allTasks.filter { task in
					task.name.lowercased().contains(searchText.lowercased()) ||
					task.type.rawValue.lowercased().contains(searchText.lowercased()) ||
					task.status.rawValue.lowercased().contains(searchText.lowercased()) ||
					task.notes.lowercased().contains(searchText.lowercased()) ||
					task.dueDate.formatted().lowercased().contains(searchText.lowercased())
				}
			}
		}
		
		@Published
		var isShowingAddTaskView: Bool = false
		
		// MARK: - CRUD Operations
		
		// ADD
		
		func addTask(name: inout String, type: TaskType, dueDate: Date, status: TaskStatus, notes: String) {
			assignDefaultTaskName(to: &name)
			
			let newItem = TaskItem(name: name, dueDate: dueDate, lastUpdated: .now,
								   type: type, status: status, notes: notes)
			allTasks.append(newItem)
		}
		
		fileprivate func assignDefaultTaskName(to name: inout String) {
			if name == "" { name = "Untitled Task" }
		}
		
		// UPDATE
		func updateTasks(with item: TaskItem) {
			guard let index = getIndex(of: item) else { return }
			allTasks[index] = item
		}
		
		fileprivate func getIndex(of item: TaskItem) -> Int? {
			return allTasks.firstIndex { $0.id == item.id }
		}
		
		// DELETE
		func deleteTasks(at offsets: IndexSet) {
			allTasks.remove(atOffsets: offsets)
		}
	}
}
