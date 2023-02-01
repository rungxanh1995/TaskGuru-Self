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
							// status-based
							pendingSection
							
							// time-based
							overdueSection
							dueTodaySection
							upcomingSection
						}
					}
					.onAppear(perform: vm.fetchTasks)
					.navigationTitle("TaskGuru")
					.toolbar {
						ToolbarItem(placement: .navigationBarTrailing) {
							addTaskButton
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
	
	private var pendingSection: some View {
		Section {
			ForEach(vm.searchResults.filter { $0.status != .done }) { task in
				NavigationLink {
					DetailView(vm: .init(for: task))
				} label: {
					HomeListCell(task: task)
				}
			}
		} header: {
			Text("Pending")
		} footer: {
			Text("Don't stress yourself too much. You got it 💪")
		}
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
