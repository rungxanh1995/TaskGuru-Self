//
//  HomeView.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-02-17.
//  Student ID: 101307949
//

import SwiftUI
import ConfettiSwiftUI

struct HomeView: View {
	@EnvironmentObject private var vm: HomeViewModel
	@StateObject private var tabState: AppState = .init()
	@State private var selectedTask: TaskItem?
	
	@Preference(\.isConfettiEnabled) private var isConfettiEnabled
	@State private var confettiCounter: Int = 0
	
	@Preference(\.isPreviewEnabled) private var isPreviewEnabled

	var body: some View {
		NavigationStack(path: $tabState.navPath) {
			List {
				if vm.allTasks.isEmpty {
					emptyTaskText
				} else {
					overdueSection
					dueTodaySection
					upcomingSection
				}
			}
			.confettiCannon(counter: $confettiCounter)
			.onChange(of: selectedTask) { _ in
				guard let selectedTask else { return }
				vm.updateTasks(with: selectedTask)
			}
			.navigationDestination(for: TaskItem.self) { task in
				DetailView(vm: .init(for: task, parentVM: vm))
			}
			.navigationTitle("TaskGuru")
			.toolbar {
				addTaskButton
			}
			.searchable(text: $vm.searchText)
			.sheet(isPresented: $vm.isShowingAddTaskView) {
				AddTask(vm: .init(parentVM: self.vm))
			}
			.fullScreenCover(item: $selectedTask) { task in
				DetailView.EditMode(vm: .init(for: task, parentVM: vm))
			}
		}
		.environmentObject(tabState)
	}
}

extension HomeView {
	@ViewBuilder
	private var emptyTaskText: some View {
		let emptyTaskListSentence: LocalizedStringKey = "Nothing yet. Tap here or \(SFSymbols.plusCircled) to add more"

		VStack {
			makeCheerfulDecorativeImage()
			HStack {
				Spacer()
				Text(emptyTaskListSentence)
					.font(.system(.callout))
					.foregroundColor(.secondary)
				Spacer()
			}
		}
		.onTapGesture { vm.isShowingAddTaskView.toggle() }
	}

	@ViewBuilder
	private var emptyFilteredListText: some View {
		let emptyListSentence: LocalizedStringKey = "No tasks"
		
		HStack {
			Spacer()
			Text(emptyListSentence)
				.font(.system(.callout))
				.foregroundColor(.secondary)
			Spacer()
		}
	}

	@ViewBuilder
	private var overdueSection: some View {
		let overdues = vm.searchResults.filter { $0.dueDate.isPastToday }

		Section {
			if overdues.isEmpty {
				emptyFilteredListText
			} else {
				ForEach(overdues) { task in
					NavigationLink(value: task) {
						HomeListCell(task: task)
					}
					.contextMenu {
						makeContextMenu(for: task)
					} preview: {
						if isPreviewEnabled {
							DetailView(vm: .init(for: task, parentVM: vm))
						} else {
							HomeListCell(task: task).padding()
						}
					}
				}
			}
		} header: {
			Text("Overdue").bold().foregroundColor(.red)
		}
	}

	@ViewBuilder
	private var dueTodaySection: some View {
		let dues = vm.searchResults.filter { $0.dueDate.isWithinToday }

		Section {
			if dues.isEmpty {
				emptyFilteredListText
			} else {
				ForEach(dues) { task in
					NavigationLink(value: task) {
						HomeListCell(task: task)
					}
					.contextMenu {
						makeContextMenu(for: task)
					} preview: {
						if isPreviewEnabled {
							DetailView(vm: .init(for: task, parentVM: vm))
						} else {
							HomeListCell(task: task).padding()
						}
					}
				}
			}
		} header: {
			Text("Due Today").bold().foregroundColor(.orange)
		}
	}

	@ViewBuilder
	private var upcomingSection: some View {
		let upcomings = vm.searchResults.filter { $0.dueDate.isInTheFuture }

		Section {
			if upcomings.isEmpty {
				emptyFilteredListText
			} else {
				ForEach(upcomings) { task in
					NavigationLink(value: task) {
						HomeListCell(task: task)
					}
					.contextMenu {
						makeContextMenu(for: task)
					} preview: {
						if isPreviewEnabled {
							DetailView(vm: .init(for: task, parentVM: vm))
						} else {
							HomeListCell(task: task).padding()
						}
					}
				}
			}
		} header: {
			Text("Upcoming").bold().foregroundColor(.mint)
		}
	}
	
	@ViewBuilder
	private func makeContextMenu(for task: TaskItem) -> some View {
		if task.isNotDone {
			Button {
				withAnimation { vm.markAsDone(task) }
				if isConfettiEnabled { confettiCounter += 1 }
			} label: {
				Label { Text("Mark as Done") } icon: { SFSymbols.checkmark }
			}
		}
		Button { selectedTask = task } label: {
			Label { Text("Edit") } icon: { SFSymbols.pencilSquare }
		}
		Divider()

		Menu {
			Button(role: .cancel) {} label: {
				Label { Text("Cancel") } icon: { SFSymbols.xmark }
			}
			Button(role: .destructive) {
				withAnimation { vm.delete(task) }
			} label: {
				Label { Text("Delete") } icon: { SFSymbols.trash }
			}
		} label: {
			Label { Text("Delete") } icon: { SFSymbols.trash }
		}
	}
	
	private var addTaskButton: some View {
		Button {
			vm.isShowingAddTaskView.toggle()
		} label: {
			Label { Text("Add Task") } icon: { SFSymbols.plus }
		}
	}
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
				.environmentObject(HomeViewModel())
    }
}
