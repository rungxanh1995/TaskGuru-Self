//
//  HomeView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI
import ConfettiSwiftUI

struct HomeView: View {
	@EnvironmentObject var vm: HomeViewModel
	@StateObject private var tabState: AppState = .init()
	@State private var selectedTask: TaskItem?

	@Preference(\.isConfettiEnabled) private var isConfettiEnabled
	@State private var confettiCounter: Int = 0

	@Preference(\.isPreviewEnabled) private var isPreviewEnabled
	@Preference(\.contextPreviewType) private var previewType

	var body: some View {
		NavigationStack(path: $tabState.navPath) {
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
					.confettiCannon(counter: $confettiCounter)
					.onAppear(perform: vm.fetchTasks)
					.onChange(of: selectedTask) { _ in vm.fetchTasks() }
					.navigationDestination(for: TaskItem.self) { task in
						DetailView(vm: .init(for: task))
					}
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						ToolbarItem(placement: .navigationBarLeading) {
							GradientNavigationTitle(text: "All Tasks")
						}
						ToolbarItem(placement: .primaryAction) {
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
					.if(isPreviewEnabled) { view in
						view.if(ContextPreviewType(rawValue: previewType) == .cell) { view in
							view.contextMenu { makeContextMenu(for: task) }
						} elseCase: { view in
							view.contextMenu { makeContextMenu(for: task) } preview: { DetailView(vm: .init(for: task)) }
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
					.if(isPreviewEnabled) { view in
						view.if(ContextPreviewType(rawValue: previewType) == .cell) { view in
							view.contextMenu { makeContextMenu(for: task) }
						} elseCase: { view in
							view.contextMenu { makeContextMenu(for: task) } preview: { DetailView(vm: .init(for: task)) }
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
					.if(isPreviewEnabled) { view in
						view.if(ContextPreviewType(rawValue: previewType) == .cell) { view in
							view.contextMenu { makeContextMenu(for: task) }
						} elseCase: { view in
							view.contextMenu { makeContextMenu(for: task) } preview: { DetailView(vm: .init(for: task)) }
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
