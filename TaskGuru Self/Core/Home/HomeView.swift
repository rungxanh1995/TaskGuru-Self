//
//  HomeView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct HomeView: View {
	
	@State
	private var isShowingAddTask: Bool = false
	
	@State
	private var searchText: String = ""
	
    var body: some View {
		NavigationView {
			List {
				overdueSection
				dueTodaySection
				upcomingSection
			}
			.navigationTitle("TaskGuru")
			.toolbar {
				addTaskButton
			}
			.searchable(text: $searchText)
			.sheet(isPresented: $isShowingAddTask) {
				AddTask()
			}
		}
    }
}

extension HomeView {
	private var overdueSection: some View {
		Section {
			ForEach(TaskItem.mockData.filter { $0.dueDate.isPastToday }) { task in
				NavigationLink {
					DetailView(task: task)
				} label: {
					HomeListCell(task: task)
				}
			}
		} header: { Text("Overdue") }
	}
	
	private var dueTodaySection: some View {
		Section {
			ForEach(TaskItem.mockData.filter { $0.dueDate.isWithinToday }) { task in
				NavigationLink {
					DetailView(task: task)
				} label: {
					HomeListCell(task: task)
				}
			}
		} header: { Text("Due Today") }
	}
	
	private var upcomingSection: some View {
		Section {
			ForEach(TaskItem.mockData.filter { $0.dueDate.isInTheFuture }) { task in
				NavigationLink {
					DetailView(task: task)
				} label: {
					HomeListCell(task: task)
				}
			}
		} header: { Text("Upcoming") }
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
