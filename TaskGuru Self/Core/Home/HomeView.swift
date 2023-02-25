//
//  HomeView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

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
					.playConfetti($confettiCounter)
					.onAppear(perform: vm.fetchTasks)
					.onChange(of: selectedTask) { _ in vm.fetchTasks() }
					.navigationDestination(for: TaskItem.self) { task in
						DetailView(vm: .init(for: task))
					}
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						ToolbarItem(placement: .principal) {
							NavigationTitle(text: "home.nav.title")
						}
						ToolbarItem(placement: .primaryAction) {
							addTaskButton
						}
						ToolbarItem(placement: .secondaryAction) {
							clearDoneTasksButton
						}
					}
					.searchable(text: $vm.searchText)
					.sheet(isPresented: $vm.isShowingAddTaskView) {
						AddTask(vm: .init(parentVM: self.vm))
					}
					.fullScreenCover(item: $selectedTask) { task in
						DetailView.EditMode(vm: .init(for: task))
					}
					.confirmationDialog(
						"home.clearDoneTasks.alert",
						isPresented: $vm.isConfirmingClearDoneTasks,
						titleVisibility: .visible
					) {
						Button("contextMenu.clearDoneTasks", role: .destructive) {
							vm.clearDoneTasks()
							haptic(.success)
						}
						Button("contextMenu.cancel", role: .cancel) { }
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
		let emptyListSentence: LocalizedStringKey = "home.info.sectionEmpty"

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
			Text("home.sections.overdue").bold().foregroundColor(.red)
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
			Text("home.sections.dueToday").bold().foregroundColor(.orange)
		}
	}

	@ViewBuilder
	private var upcomingSection: some View {
		let upcomings = vm.searchResults.filter { $0.dueDate.isFromTomorrow }

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
			Text("home.sections.upcoming").bold().foregroundColor(.mint)
		}
	}

	@ViewBuilder
	private func makeContextMenu(for task: TaskItem) -> some View {
		markAsButtons(for: task)
		Button { selectedTask = task } label: {
			Label { Text("contextMenu.task.edit") } icon: { SFSymbols.pencilSquare }
		}

		Menu {
			Button(role: .cancel) {} label: {
				Label { Text("contextMenu.cancel") } icon: { SFSymbols.xmark }
			}
			Button(role: .destructive) {
				withAnimation { vm.delete(task) }
				haptic(.success)
			} label: {
				Label { Text("contextMenu.task.delete") } icon: { SFSymbols.trash }
			}
		} label: {
			Label { Text("contextMenu.task.delete") } icon: { SFSymbols.trash }
		}
	}

	private func markAsButtons(for task: TaskItem) -> some View {
		switch task.status {
		case .new:
			return Section {
				Button {
					withAnimation { vm.markAsInProgress(task) }
				} label: {
					Label { Text("contextMenu.task.markInProgress") } icon: { SFSymbols.circleArrows }
				}
				Button {
					withAnimation { vm.markAsDone(task) }
					if isConfettiEnabled { confettiCounter += 1}
				} label: {
					Label { Text("contextMenu.task.markDone") } icon: { SFSymbols.checkmark }
				}
			} header: {
				Text("contextMenu.task.markAs")
			}
		case .inProgress:
			return Section {
				Button {
					withAnimation { vm.markAsNew(task) }
				} label: {
					Label { Text("contextMenu.task.markNew") } icon: { SFSymbols.sparkles }
				}
				Button {
					withAnimation { vm.markAsDone(task) }
					if isConfettiEnabled { confettiCounter += 1}
				} label: {
					Label { Text("contextMenu.task.markDone") } icon: { SFSymbols.checkmark }
				}
			} header: {
				Text("contextMenu.task.markAs")
			}
		case .done:
			return Section {
				Button {
					withAnimation { vm.markAsNew(task) }
				} label: {
					Label { Text("contextMenu.task.markNew") } icon: { SFSymbols.sparkles }
				}
				Button {
					withAnimation { vm.markAsInProgress(task) }
				} label: {
					Label { Text("contextMenu.task.markInProgress") } icon: { SFSymbols.circleArrows }
				}
			} header: {
				Text("contextMenu.task.markAs")
			}
		}
	}

	private var addTaskButton: some View {
		Button {
			vm.isShowingAddTaskView.toggle()
		} label: {
			Label { Text("label.task.add") } icon: { SFSymbols.plus }
		}
	}

	private var clearDoneTasksButton: some View {
		Button(role: .destructive) {
			withAnimation { vm.isConfirmingClearDoneTasks.toggle() }
		} label: {
			Label { Text("Clear Done Tasks") } icon: { SFSymbols.trash }
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
			.environmentObject(HomeViewModel())
	}
}
