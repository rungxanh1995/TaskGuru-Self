//
//  HomeView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct HomeView: View {
	@StateObject var vm: ViewModel
	
	init(vm: HomeView.ViewModel = .init()) {
		_vm = StateObject(wrappedValue: vm)
	}
	
	var body: some View {
		NavigationView {
			ZStack {
				if vm.isFetchingData {
					ProgressView()
				} else {
					List {
						if vm.allTasks.isEmpty {
							emptyTaskText
						} else {
							overdueSection
							dueTodaySection
							upcomingSection
						}
					}
					.navigationTitle("TaskGuru")
					.listStyle(.grouped)
					.toolbar {
						ToolbarItem(placement: .navigationBarTrailing) {
							addTaskButton
						}
						ToolbarItem(placement: .navigationBarLeading) {
							EditButton()
						}
					}
					.searchable(text: $vm.searchText)
					.sheet(isPresented: $vm.isShowingAddTaskView) {
						AddTask(vm: .init(parentVM: self.vm))
					}
				}
			}
		}
	}
}

extension HomeView {
	@ViewBuilder
	private var emptyTaskText: some View {
		
		let emptyTaskListSentence: LocalizedStringKey = "Nothing yet. Tap here or \(SFSymbols.plusCircled) to add more"
		
		HStack {
			Spacer()
			Text(emptyTaskListSentence)
				.font(.system(.callout, design: .rounded))
				.foregroundColor(.secondary)
			Spacer()
		}
		.onTapGesture { vm.isShowingAddTaskView.toggle() }
	}
	
	private var overdueSection: some View {
		Section {
			ForEach(vm.searchResults.filter { $0.dueDate.isPastToday }) { task in
				NavigationLink {
					DetailView(vm: .init(for: task))
				} label: {
					HomeListCell(task: task)
				}
			}
			.onDelete(perform: vm.deleteTasks)
		} header: { Text("Overdue") }
	}
	
	private var dueTodaySection: some View {
		Section {
			ForEach(vm.searchResults.filter { $0.dueDate.isWithinToday }) { task in
				NavigationLink {
					DetailView(vm: .init(for: task))
				} label: {
					HomeListCell(task: task)
				}
			}
			.onDelete(perform: vm.deleteTasks)
		} header: { Text("Due Today") }
	}
	
	private var upcomingSection: some View {
		Section {
			ForEach(vm.searchResults.filter { $0.dueDate.isInTheFuture }) { task in
				NavigationLink {
					DetailView(vm: .init(for: task))
				} label: {
					HomeListCell(task: task)
				}
			}
			.onDelete(perform: vm.deleteTasks)
		} header: { Text("Upcoming") }
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
	}
}
