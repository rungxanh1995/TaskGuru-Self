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
		
		@Published
		var isFetchingData: Bool = false
		
		private let storageProvider: StorageProvider
		
		init(storageProvider: StorageProvider = StorageProviderImpl.standard) {
			self.storageProvider = storageProvider
			fetchTasks()
		}
		
		func fetchTasks() {
			DispatchQueue.main.async {
				print("Fetching cached tasks from Core Data")
				self.allTasks = self.storageProvider.fetch()
			}
		}
		
		private func saveThenRefetchData() {
			isFetchingData = true
			defer { isFetchingData = false }
			
			storageProvider.saveAndHandleError()
			fetchTasks()
		}
		
		func deleteTasks(at offsets: IndexSet) -> Void {
			guard let index = offsets.first else { return }
			let task = allTasks[index]
			
			storageProvider.context.delete(task)
			saveThenRefetchData()
		}
	}
}
