//
//  HomeView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct HomeView: View {
	
	@State private var isShowingAddTask: Bool = false
	@State private var selectedTask: TaskItem?
	
	@State private var searchText: String = ""
	
	var noPendingTasksLeft: Bool {
		TaskItem.mockData.filter{ $0.isNotDone }.isEmpty
	}
	
	var body: some View {
		NavigationStack {
			List {
				// status-based
				pendingSection
				
				timeBasedSections
			}
			.navigationDestination(for: TaskItem.self) { taskItem in
				DetailView(task: taskItem)
			}
			.navigationTitle("TaskGuru")
			.toolbar {
				addTaskButton
			}
			.searchable(text: $searchText)
			.sheet(isPresented: $isShowingAddTask) {
				AddTask()
			}
			.fullScreenCover(item: $selectedTask) { _ in
				EditView()
			}
		}
	}
}

extension HomeView {
	private var pendingSection: some View {
		Section {
			if noPendingTasksLeft {
				makeCheerfulDecorativeImage()
					.grayscale(1.0)
			} else {
				ForEach(TaskItem.mockData.filter { $0.status != .done }) { task in
					NavigationLink(value: task) {
						HomeListCell(task: task)
					}
					.contextMenu {
						makeContextMenu(for: task)
					} preview: { DetailView(task: task) }
				}
			}
		} header: {
			Text("Pending Tasks")
		} footer: {
			if noPendingTasksLeft {
				Text("You're free! Enjoy your much deserved time 🥳")
			} else {
				Text("Don't stress yourself too much. You got it 💪")
			}
		}
		.headerProminence(.increased)
	}
	
	private var timeBasedSections: some View {
		Section {
			overdueSection
			dueTodaySection
			upcomingSection
		} header: {
			Text("All Tasks")
		}
		.headerProminence(.increased)
	}
	
	private var overdueSection: some View {
		Section {
			ForEach(TaskItem.mockData.filter { $0.dueDate.isPastToday }) { task in
				NavigationLink(value: task) {
					HomeListCell(task: task)
				}
				.contextMenu {
					makeContextMenu(for: task)
				} preview: { DetailView(task: task) }
			}
		} header: {
			Text("Overdue")
				.bold()
				.foregroundColor(.red)
		}
	}
	
	private var dueTodaySection: some View {
		Section {
			ForEach(TaskItem.mockData.filter { $0.dueDate.isWithinToday }) { task in
				NavigationLink(value: task) {
					HomeListCell(task: task)
				}
				.contextMenu {
					makeContextMenu(for: task)
				} preview: { DetailView(task: task) }
			}
		} header: {
			Text("Due Today")
				.bold()
				.foregroundColor(.orange)
		}
	}
	
	private var upcomingSection: some View {
		Section {
			ForEach(TaskItem.mockData.filter { $0.dueDate.isInTheFuture }) { task in
				NavigationLink(value: task) {
					HomeListCell(task: task)
				}
				.contextMenu {
					makeContextMenu(for: task)
				} preview: { DetailView(task: task) }
			}
		} header: {
			Text("Upcoming")
				.bold()
				.foregroundColor(.mint)
		}
	}
	
	@ViewBuilder
	private func makeContextMenu(for task: TaskItem) -> some View {
		if task.isNotDone {
			Button {
				// mark task as done here...
			} label: {
				Label("Mark as Done", systemImage: "checkmark")
			}
		}
		Button { selectedTask = task } label: {
			Label("Edit", systemImage: "square.and.pencil")
		}
		Divider()
		
		Menu {
			Button(role: .cancel) {} label: {
				Label("Cancel", systemImage: "xmark")
			}
			Button(role: .destructive) {
				// delete task here...
			} label: {
				Label("Delete", systemImage: "trash")
			}
		} label: {
			Label("Delete", systemImage: "trash")
		}
	}
	
	private var addTaskButton: some View {
		Button {
			isShowingAddTask.toggle()
		} label: {
			Label("Add Task", systemImage: "plus.circle")
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
