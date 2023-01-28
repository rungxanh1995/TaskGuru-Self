//
//  HomeView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct HomeView: View {
	@StateObject
	var vm: ViewModel
	
	init(vm: HomeView.ViewModel = .init()) {
		_vm = StateObject(wrappedValue: vm)
	}
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					if vm.personalTasks.isEmpty {
						emptyTaskText
					} else {
						ForEach(vm.personalTasks) { task in
							NavigationLink(task.name) {
								DetailView(task: task.name)
							}
						}
					}
				} header: {
					HStack {
						Image(systemName: "person.fill")
						Text("Personal Tasks")
					}
				}

				Section {
					if vm.workTasks.isEmpty {
						emptyTaskText
					} else {
						ForEach(vm.workTasks) { task in
							NavigationLink(task.name) {
								DetailView(task: task.name)
							}
						}
					}
				} header: {
					HStack {
						Image(systemName: "building.2.fill")
						Text("Work Tasks")
					}
				}
				
				Section {
					if vm.schoolTasks.isEmpty {
						emptyTaskText
					} else {
						ForEach(vm.schoolTasks) { task in
							NavigationLink(task.name) {
								DetailView(task: task.name)
							}
						}
					}
				} header: {
					HStack {
						Image(systemName: "graduationcap.fill")
						Text("School Tasks")
					}
				}
				
				Section {
					if vm.otherTasks.isEmpty {
						emptyTaskText
					} else {
						ForEach(vm.otherTasks) { task in
							NavigationLink(task.name) {
								DetailView(task: task.name)
							}
						}
					}
				} header: {
					HStack {
						Image(systemName: "list.bullet.rectangle.portrait.fill")
						Text("Other Tasks")
					}
				}
			}
			.navigationTitle("TaskGuru")
			.toolbar {
				addTaskButton
			}
			.sheet(isPresented: $vm.isShowingAddTaskView) {
				AddTask()
			}
		}
	}
}

extension HomeView {
	@ViewBuilder
	private var emptyTaskText: some View {
		
		let emptyTaskListSentence: LocalizedStringKey = "Nothing yet. Tap \(Image(systemName: "plus.circle")) to add more"
		
		HStack {
			Spacer()
			Text(emptyTaskListSentence)
				.font(.system(.callout, design: .rounded))
				.foregroundColor(.secondary)
			Spacer()
		}
	}
	
	private var addTaskButton: some View {
		Button {
			vm.isShowingAddTaskView.toggle()
		} label: {
			Label("Add Task", systemImage: "plus.circle")
		}
	}
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
			.preferredColorScheme(.dark)
    }
}
