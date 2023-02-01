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
		
		var taskIsNewOrInProgress: Bool {
			return task.status == .new || task.status == .inProgress
		}
		
		let parentVM: HomeView.ViewModel
		
		init(for task: TaskItem, parentVM: HomeView.ViewModel) {
			self.task = task
			self.parentVM = parentVM
		}
		
		func updateItemInItsSource() {
			parentVM.updateTasks(with: task)
		}
		
		func deleteTask() {
			// TODO: implement when persistence is deployed
		}
		
		func markTaskAsDone() {
			task.status = .done
			updateItemInItsSource()
		}
	}
}
