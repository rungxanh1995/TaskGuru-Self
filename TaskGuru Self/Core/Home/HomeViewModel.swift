//
//  HomeViewModel.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

extension HomeView {
	final class ViewModel: ObservableObject {

		@Published private(set) var allTasks: [TaskItem] = .init()

		@Published var searchText = ""

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

		@Published var isShowingAddTaskView: Bool = false
		@Published var isFetchingData: Bool = false

		private let storageProvider: StorageProvider

		init(storageProvider: StorageProvider = StorageProviderImpl.standard) {
			self.storageProvider = storageProvider
			fetchTasks()
		}

		func fetchTasks() {
			isFetchingData = true
			defer {
				print("Finished fetching cached data")
				isFetchingData = false
			}

			print("Fetching cached tasks from Core Data")
			self.allTasks = self.storageProvider.fetch()
		}

		func delete(_ task: TaskItem) {
			storageProvider.context.delete(task)
			saveAndHandleError()
			fetchTasks()
			haptic(.success)
		}

		private func saveAndHandleError() {
			storageProvider.saveAndHandleError()
		}

		func markAsDone(_ task: TaskItem) {
			task.status = .done
			saveAndHandleError()
			fetchTasks()
			haptic(.success)
		}
	}
}
