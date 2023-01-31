//
//  HomeViewModel.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation
import Combine

extension HomeView {
	final class ViewModel: ObservableObject {
		@Published
		private(set) var allTasks: [TaskItem] = .init()
		
		@Published
		private var cachedTasks: [CachedTask] = .init()
		private var cancellables: Set<AnyCancellable> = []
		
		@Published
		var isShowingAddTaskView: Bool = false
		
		private let storageProvider: StorageProvider
		
		init(storageProvider: StorageProvider = StorageProviderImpl.standard) {
			self.storageProvider = storageProvider
			fetchCachedTasks()
			convertCachedDataToTasks()
			print("Cached tasks length: \(cachedTasks.count)")
			print("All tasks length: \(allTasks.count)")
		}
		
		func fetchCachedTasks() {
			DispatchQueue.main.async {
				print("Fetching cached tasks from Core Data")
				self.cachedTasks = self.storageProvider.fetch()
			}
		}
		
		func convertCachedDataToTasks() {
			guard allTasks.isEmpty else { return }
			$cachedTasks.sink { cachedData in
				cachedData.forEach { [weak self] cachedTask in
					self?.allTasks.append(TaskEntityConverter.convertToTaskItem(from: cachedTask))
				}
				print("Finished converting cached data to tasks")
			}.store(in: &cancellables)
		}
		
		private func saveThenRefetchData() {
			storageProvider.saveAndHandleError()
			fetchCachedTasks()
		}
		
		// MARK: - CRUD Operations
		
		// ADD
		
		func addTask(name: inout String, type: TaskItem.TaskType, dueDate: Date,
					 status: TaskItem.TaskStatus, notes: String) -> Void {
			assignDefaultTaskName(to: &name)
			
			let newItem = TaskItem(name: name, type: type, dueDate: dueDate, status: status, notes: notes)
			addTask(newItem)
		}
		
		fileprivate func addTask(_ newItem: TaskItem) -> Void {
			allTasks.append(newItem)
			addCachedTask(using: newItem)
		}
		
		fileprivate func assignDefaultTaskName(to name: inout String) -> Void {
			if name == "" { name = "Untitled Task" }
		}
		
		func addCachedTask(using taskItem: TaskItem) {
			let taskToCache = CachedTask(context: storageProvider.context)
			taskToCache.cd_id = taskItem.id
			taskToCache.cd_name = taskItem.name
			taskToCache.cd_dueDate = taskItem.dueDate
			taskToCache.cd_type = taskItem.type.rawValue
			taskToCache.cd_status = taskItem.status.rawValue
			taskToCache.cd_notes = taskItem.notes
			taskToCache.cd_lastUpdated = taskItem.lastUpdated
			
			saveThenRefetchData()
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
			
			guard let index = offsets.first else { return }
			let cachedTask = cachedTasks[index]
			
			storageProvider.context.delete(cachedTask)
			saveThenRefetchData()
		}
	}
}
