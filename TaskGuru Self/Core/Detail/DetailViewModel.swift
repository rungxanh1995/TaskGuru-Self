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
	}
}
