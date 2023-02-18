//
//  HomeViewModel.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

final class HomeViewModel: ObservableObject {

	@Published private(set) var allTasks: [TaskItem] = .init()

	@Published var searchText = ""

	var searchResults: [TaskItem] {
		if searchText.isEmpty {
			return allTasks
		} else {
			return allTasks.filter { task in
				task.name.localizedCaseInsensitiveContains(searchText) ||
				task.type.rawValue.localizedCaseInsensitiveContains(searchText) ||
				task.status.rawValue.localizedCaseInsensitiveContains(searchText) ||
				task.notes.localizedCaseInsensitiveContains(searchText) ||
				task.dueDate.formatted().localizedCaseInsensitiveContains(searchText)
			}
		}
	}

	var pendingTasks: [TaskItem] { allTasks.filter { $0.isNotDone } }

	@Published var isShowingAddTaskView: Bool = false
	@Published var isFetchingData: Bool = false

	var noPendingTasksLeft: Bool { searchResults.filter { $0.isNotDone }.isEmpty }

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
