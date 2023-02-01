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
				if vm.isFetchingData {
					ProgressView()
				} else if vm.allTasks.isEmpty {
					emptyTaskText
				} else {
					personalTasksSection
					schoolTasksSection
					workTasksSection
					otherTasksSection
				}
			}
			
			.navigationTitle("TaskGuru")
			.toolbar {
				addTaskButton
			}
			.onAppear { vm.fetchTasks() }
			.searchable(text: $vm.searchText)
			.sheet(isPresented: $vm.isShowingAddTaskView) {
				AddTask(vm: .init(parentVM: self.vm))
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
		.onTapGesture {
			vm.isShowingAddTaskView.toggle()
			haptic(.success)
		}
	}
	
	private var personalTasksSection: some View {
		Section {
			ForEach(vm.searchResults.filter{ $0.type == .personal }) { task in
				NavigationLink {
					DetailView(vm: .init(for: task))
				} label: {
					HomeListCell(task: task)
				}
			}
			.onDelete(perform: vm.deleteTasks)
		} header: {
			HStack {
				SFSymbols.personFilled
				Text("Personal Tasks")
			}
		}
	}
	
	private var schoolTasksSection: some View {
		Section {
			ForEach(vm.searchResults.filter{ $0.type == .school }) { task in
				NavigationLink {
					DetailView(vm: .init(for: task))
				} label: {
					HomeListCell(task: task)
				}
			}
			.onDelete(perform: vm.deleteTasks)
		} header: {
			HStack {
				SFSymbols.graduationCapFilled
				Text("School Tasks")
			}
		}
	}
	
	private var workTasksSection: some View {
		Section {
			ForEach(vm.searchResults.filter{ $0.type == .work }) { task in
				NavigationLink {
					DetailView(vm: .init(for: task))
				} label: {
					HomeListCell(task: task)
				}
			}
			.onDelete(perform: vm.deleteTasks)
		} header: {
			HStack {
				SFSymbols.buildingFilled
				Text("Work Tasks")
			}
		}
	}
	
	private var otherTasksSection: some View {
		Section {
			ForEach(vm.searchResults.filter{ $0.type == .other }) { task in
				NavigationLink {
					DetailView(vm: .init(for: task))
				} label: {
					HomeListCell(task: task)
				}
			}
			.onDelete(perform: vm.deleteTasks)
		} header: {
			HStack {
				SFSymbols.listFilled
				Text("Other Tasks")
			}
		}
	}
	
	private var addTaskButton: some View {
		Button {
			vm.isShowingAddTaskView.toggle()
			haptic(.success)
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
