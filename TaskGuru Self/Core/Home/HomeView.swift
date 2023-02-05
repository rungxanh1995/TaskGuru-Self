//
//  HomeView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct HomeView: View {
	@StateObject var vm: ViewModel
	@State private var selectedTask: TaskItem?

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

							timeBasedSections
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
					.fullScreenCover(item: $selectedTask) { task in
						DetailView.EditMode(vm: .init(for: task))
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
			ForEach(vm.searchResults.filter { $0.isNotDone }) { task in
				NavigationLink {
					DetailView(vm: .init(for: task))
				} label: {
					HomeListCell(task: task)
				}
				.contextMenu {
					makeContextMenu(for: task)
				} preview: { DetailView(vm: .init(for: task)) }
			}
		} header: {
			Text("Pending Tasks")
		} footer: {
			Text("Don't stress yourself too much. You got it 💪")
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
			ForEach(vm.searchResults.filter { $0.dueDate.isPastToday }) { task in
				NavigationLink {
					DetailView(vm: .init(for: task))
				} label: {
					HomeListCell(task: task)
				}
				.contextMenu {
					makeContextMenu(for: task)
				} preview: { DetailView(vm: .init(for: task)) }
			}
		} header: {
			Text("Overdue")
				.bold()
				.foregroundColor(.red)
		}
	}

	private var dueTodaySection: some View {
		Section {
			ForEach(vm.searchResults.filter { $0.dueDate.isWithinToday }) { task in
				NavigationLink {
					DetailView(vm: .init(for: task))
				} label: {
					HomeListCell(task: task)
				}
				.contextMenu {
					makeContextMenu(for: task)
				} preview: { DetailView(vm: .init(for: task)) }
			}
		} header: {
			Text("Due Today")
			.bold()
			.foregroundColor(.orange)
		}
	}

	private var upcomingSection: some View {
		Section {
			ForEach(vm.searchResults.filter { $0.dueDate.isInTheFuture }) { task in
				NavigationLink {
					DetailView(vm: .init(for: task))
				} label: {
					HomeListCell(task: task)
				}
				.contextMenu {
					makeContextMenu(for: task)
				} preview: { DetailView(vm: .init(for: task)) }
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
			Button { vm.markAsDone(task) } label: {
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
			Button(role: .destructive) { vm.delete(task) } label: {
				Label("Delete", systemImage: "trash")
			}
		} label: {
			Label("Delete", systemImage: "trash")
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
	}
}
