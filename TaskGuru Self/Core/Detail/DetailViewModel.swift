//
//  DetailViewModel.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

extension DetailView {
	final class ViewModel: ObservableObject {
		@Published var task: TaskItem
		
		let parentVM: HomeViewModel
		
		init(for task: TaskItem, parentVM: HomeViewModel) {
			self.task = task
			self.parentVM = parentVM
		}
		
		func updateItemInItsSource() {
			parentVM.updateTasks(with: task)
		}
		
		func deleteTask() {
			// TODO: implement when persistence is deployed
			parentVM.delete(task)
		}
		
		func markTaskAsDone() {
			task.status = .done
			updateItemInItsSource()
		}
	}
}
