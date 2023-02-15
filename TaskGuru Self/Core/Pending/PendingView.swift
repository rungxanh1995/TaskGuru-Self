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

	var body: some View {
		NavigationStack(path: $tabState.navPath) {
			ZStack {
				if vm.isFetchingData {
					ProgressView { Text("Fetching data") }
				} else if vm.noPendingTasksLeft {
					emptyStateImage.padding()
				} else {
					List { pendingSection }
				}
			}
			.onAppear(perform: vm.fetchTasks)
			.onChange(of: selectedTask) { _ in vm.fetchTasks() }
			.navigationDestination(for: TaskItem.self) { task in
				DetailView(vm: .init(for: task))
			}
			.navigationTitle("Pending Tasks")
			.toolbar {
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

			Text("You're free! Enjoy your much deserved time 🥳")
				.font(.footnote)
				.foregroundColor(.secondary)
		}
	}

	private var pendingSection: some View {
		Section {
			ForEach(vm.pendingTasks) { task in
				NavigationLink(value: task) {
					HomeListCell(task: task)
				}
				.contextMenu {
					makeContextMenu(for: task)
				} preview: { DetailView(vm: .init(for: task)) }
			}
		} footer: {
			Text("Don't stress yourself too much. You got it 💪")
		}
		.headerProminence(.increased)
	}

	@ViewBuilder
	private func makeContextMenu(for task: TaskItem) -> some View {
		if task.isNotDone {
			Button {
				withAnimation { vm.markAsDone(task) }
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

struct PendingView_Previews: PreviewProvider {
	static var previews: some View {
		PendingView()
			.environmentObject(HomeViewModel())
	}
}
