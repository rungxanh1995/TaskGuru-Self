//
//  PendingView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-17.
//

import SwiftUI
import ConfettiSwiftUI

struct PendingView: View {
	@EnvironmentObject private var vm: HomeViewModel
	@StateObject private var tabState: AppState = .init()
	@State private var selectedTask: TaskItem?
	
	@Preference(\.isConfettiEnabled) private var isConfettiEnabled
	@State private var confettiCounter: Int = 0
	
	@Preference(\.isPreviewEnabled) private var isPreviewEnabled
	
	var body: some View {
		NavigationStack(path: $tabState.navPath) {
			ZStack {
				if vm.noPendingTasksLeft {
					emptyStateImage.padding()
				} else {
					List { pendingSection }
				}
			}
			.confettiCannon(counter: $confettiCounter)
			.navigationDestination(for: TaskItem.self) { task in
				DetailView(vm: .init(for: task, parentVM: vm))
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					GradientNavigationTitle(text: "Pending Tasks")
				}
				ToolbarItem(placement: .primaryAction) {
					addTaskButton
				}
			}
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
				} preview: {
					if isPreviewEnabled {
						DetailView(vm: .init(for: task, parentVM: vm))
					} else {
						HomeListCell(task: task).padding()
					}
				}
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

struct PendingView_Previews: PreviewProvider {
	static var previews: some View {
		PendingView()
			.environmentObject(HomeViewModel())
	}
}

