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
			Form {
				personalTasksSection
				schoolTasksSection
				workTasksSection
				otherTasksSection
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
	private var personalTasksSection: some View {
		Section {
			ForEach(TaskItem.mockData.filter{ $0.type == .personal }) { task in
				NavigationLink {
					DetailView(task: task)
				} label: {
					HomeListCell(task: task)
				}
			}
		} header: {
			HStack {
				SFSymbols.personFilled
				Text("Personal Tasks")
			}
		}
	}
	
	private var schoolTasksSection: some View {
		Section {
			ForEach(TaskItem.mockData.filter{ $0.type == .school }) { task in
				NavigationLink {
					DetailView(task: task)
				} label: {
					HomeListCell(task: task)
				}
			}
		} header: {
			HStack {
				SFSymbols.graduationCapFilled
				Text("School Tasks")
			}
		}
	}
	
	private var workTasksSection: some View {
		Section {
			ForEach(TaskItem.mockData.filter{ $0.type == .work }) { task in
				NavigationLink {
					DetailView(task: task)
				} label: {
					HomeListCell(task: task)
				}
			}
		} header: {
			HStack {
				SFSymbols.buildingFilled
				Text("Work Tasks")
			}
		}
	}
	
	private var otherTasksSection: some View {
		Section {
			ForEach(TaskItem.mockData.filter{ $0.type == .other }) { task in
				NavigationLink {
					DetailView(task: task)
				} label: {
					HomeListCell(task: task)
				}
			}
		} header: {
			HStack {
				SFSymbols.listFilled
				Text("Other Tasks")
			}
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
