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
							NavigationLink {
								DetailView(vm: .init(for: task, parentVM: self.vm))
							} label: {
								HomeListCell(task: task)
							}
						}
						.onDelete(perform: vm.deletePersonalTasks)
					}
				} header: {
					HStack {
						SFSymbols.personFilled
						Text("Personal Tasks")
					}
				}

				Section {
					if vm.workTasks.isEmpty {
						emptyTaskText
					} else {
						ForEach(vm.workTasks) { task in
							NavigationLink {
								DetailView(vm: .init(for: task, parentVM: self.vm))
							} label: {
								HomeListCell(task: task)
							}
						}
						.onDelete(perform: vm.deleteWorkTasks)
					}
				} header: {
					HStack {
						SFSymbols.buildingFilled
						Text("Work Tasks")
					}
				}
				
				Section {
					if vm.schoolTasks.isEmpty {
						emptyTaskText
					} else {
						ForEach(vm.schoolTasks) { task in
							NavigationLink {
								DetailView(vm: .init(for: task, parentVM: self.vm))
							} label: {
								HomeListCell(task: task)
							}
						}
						.onDelete(perform: vm.deleteSchoolTasks)
					}
				} header: {
					HStack {
						SFSymbols.graduationCapFilled
						Text("School Tasks")
					}
				}
				
				Section {
					if vm.otherTasks.isEmpty {
						emptyTaskText
					} else {
						ForEach(vm.otherTasks) { task in
							NavigationLink {
								DetailView(vm: .init(for: task, parentVM: self.vm))
							} label: {
								HomeListCell(task: task)
							}
						}
						.onDelete(perform: vm.deleteOtherTasks)
					}
				} header: {
					HStack {
						SFSymbols.listFilled
						Text("Other Tasks")
					}
				}
			}
			.navigationTitle("TaskGuru")
			.toolbar {
				addTaskButton
			}
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
		.onTapGesture { vm.isShowingAddTaskView.toggle() }
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
