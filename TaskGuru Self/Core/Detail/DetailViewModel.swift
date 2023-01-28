//
//  DetailViewModel.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

extension DetailView {
	final class ViewModel: ObservableObject {
		@Published
		var task: TaskItem
		
		let parentVM: HomeView.ViewModel
		
		init(for task: TaskItem, parentVM: HomeView.ViewModel) {
			self.task = task
			self.parentVM = parentVM
		}
		
		func colorForStatus() -> Color {
			switch task.status {
				case .new: return Color.gray
				case .inProgress: return Color.orange
				case .done: return Color.mint
			}
		}
		
		/// Shows green when not approaching today's date, orange on today's date, and red when passed today's date
		func colorForDueDate() -> Color {
			if task.dueDate.isWithinToday {
				return Color.orange
			} else if task.dueDate > Date.now {
				return Color.mint
			} else {
				return Color.red
			}
		}
	}
}
