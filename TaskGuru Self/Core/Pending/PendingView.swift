//
//  PendingView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-12.
//

import SwiftUI

struct PendingView: View {
	@EnvironmentObject private var vm: HomeViewModel
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
					ProgressView { Text("pending.info.fetchingData") }
				} else if vm.noPendingTasksLeft {
					emptyStateImage.padding()
				} else {
					List {
						pendingInThePastSection
						pendingTodaySection
						pendingFromTomorrowSection
						encouragingMessage.listRowBackground(Color.clear)
					}
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
					NavigationTitle(text: "pending.nav.title")
				}
				ToolbarItem(placement: .primaryAction) {
					addTaskButton
				}
			}
			.sheet(isPresented: $vm.isShowingAddTaskView) {
				AddTask(vm: .init(parentVM: self.vm))
			}
			.fullScreenCover(item: $selectedTask) { task in
				DetailView.EditMode(vm: .init(for: task))
			}
		}
		.environmentObject(tabState)
	}
}

extension PendingView {
	private var emptyStateImage: some View {
		VStack {
			makeCheerfulDecorativeImage()

			Text("pending.info.listEmty")
				.font(.callout)
				.foregroundColor(.secondary)
		}
	}

	private var encouragingMessage: some View {
		Text("pending.info.listNotEmpty")
			.font(.footnote)
			.foregroundColor(.secondary)
	}

	@ViewBuilder private var pendingInThePastSection: some View {
		let pendings = vm.pendingTasks.filter { $0.dueDate.isPastToday }

		if pendings.isEmpty == false {
			Section {
				ForEach(pendings) { task in
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
			} header: {
				Text("pending.sections.overdue").bold().foregroundColor(.red)
			}
		}
	}

	@ViewBuilder private var pendingTodaySection: some View {
		let pendings = vm.pendingTasks.filter { $0.dueDate.isWithinToday }

		if pendings.isEmpty == false {
			Section {
				ForEach(pendings) { task in
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
			} header: {
				Text("pending.sections.dueToday").bold().foregroundColor(.orange)
			}
		}
	}

	@ViewBuilder private var pendingFromTomorrowSection: some View {
		let pendings = vm.pendingTasks.filter { $0.dueDate.isFromTomorrow }

		if pendings.isEmpty == false {
			Section {
				ForEach(pendings) { task in
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
			} header: {
				Text("pending.sections.upcoming").bold().foregroundColor(.mint)
			}
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

	@ViewBuilder
	private func markAsButtons(for task: TaskItem) -> some View {
		switch task.status {
		case .new:
			Section {
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
			Section {
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
		case .done: EmptyView()	// shouldn't happen in Pending view
		}
	}

	private var addTaskButton: some View {
		Button {
			vm.isShowingAddTaskView.toggle()
		} label: {
			Label { Text("label.task.add") } icon: { SFSymbols.plus }
		}
	}
}

struct PendingView_Previews: PreviewProvider {
	static var previews: some View {
		PendingView()
			.environmentObject(HomeViewModel())
	}
}
