//
//  PendingView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-12.
//

import SwiftUI

struct PendingView: View {
	@EnvironmentObject var vm: HomeViewModel
	@EnvironmentObject private var appState: AppState
	@State private var selectedTask: TaskItem?

	var body: some View {
		NavigationStack(path: $appState.navPath) {
			ZStack {
				if vm.isFetchingData {
					ProgressView()
				} else {
					List {
						pendingSection
					}
					.onAppear(perform: vm.fetchTasks)
					.onChange(of: selectedTask) { _ in vm.fetchTasks() }
					.navigationDestination(for: TaskItem.self) { task in
						DetailView(vm: .init(for: task))
					}
					.navigationTitle("Pending Tasks")
					.fullScreenCover(item: $selectedTask) { task in
						DetailView.EditMode(vm: .init(for: task))
					}
				}
			}
		}
	}
}

extension PendingView {
	private var pendingSection: some View {
		Section {
			if vm.noPendingTasksLeft {
				makeCheerfulDecorativeImage()
					.grayscale(1.0)
			} else {
				ForEach(vm.searchResults.filter { $0.isNotDone }) { task in
					NavigationLink(value: task) {
						HomeListCell(task: task)
					}
					.contextMenu {
						makeContextMenu(for: task)
					} preview: { DetailView(vm: .init(for: task)) }
				}
			}
		} footer: {
			if vm.noPendingTasksLeft {
				Text("You're free! Enjoy your much deserved time 🥳")
			} else {
				Text("Don't stress yourself too much. You got it 💪")
			}
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
}
