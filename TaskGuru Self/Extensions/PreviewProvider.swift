//
//  PreviewProvider.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

extension PreviewProvider {
	static var dev: DeveloperPreview { .instance }
}

final class DeveloperPreview {
	static let instance: DeveloperPreview = .init()
	private init() {}
	
	let homeVM: HomeView.ViewModel = .init()
	let task: TaskItem = .init(name: "Group project presentation", type: .school, dueDate: .now, status: .inProgress, notes: "An advanced ToDo application with several types of tasks and ability to create new tasks and new kinds of tasks.")
}
