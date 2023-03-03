//
//  DetailView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

extension DetailView {
	struct ViewMode: View {
		@ObservedObject var vm: DetailView.ViewModel

		@Environment(\.dismiss) var dismissThisView

		@State private var isShowingEdit: Bool = false
		@State private var isMarkingAsDone: Bool = false
		@State private var isDeletingTask: Bool = false

		private let columns = [
			GridItem(.flexible(minimum: 120.0, maximum: 600.0)),
			GridItem(.flexible(minimum: 120.0, maximum: 600.0))
		]

		var body: some View {
			ScrollView {
				VStack(spacing: 8) {
					DetailGridCell(title: vm.task.name, caption: "taskDetail.cell.name.caption")

					LazyVGrid(columns: columns) {
						DetailGridCell(title: vm.task.status.rawValue, caption: "taskDetail.cell.status.caption",
													 titleColor: vm.task.colorForStatus())
						DetailGridCell(title: vm.task.numericDueDate, caption: "taskDetail.cell.dueDate.caption",
													 titleColor: vm.task.colorForDueDate())
						DetailGridCell(title: vm.task.type.rawValue, caption: "taskDetail.cell.type.caption")
						DetailGridCell(title: vm.task.priority.rawValue, caption: "taskDetail.cell.priority.caption",
													 titleColor: vm.task.colorForPriority())
					}

					if vm.task.notes.isEmpty == false {
						DetailGridCell(title: vm.task.notes, caption: "taskDetail.cell.notes.caption")
					}
				}
				.padding()

				Text("Last updated at \(vm.task.formattedLastUpdated)")
					.font(.system(.caption, design: .rounded))
					.foregroundColor(.secondary)
					.padding([.bottom])
			}
			.navigationTitle("taskDetail.nav.title")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				// swiftlint:disable multiple_closures_with_trailing_closure
				if vm.taskIsNewOrInProgress {
					ToolbarItemGroup(placement: .primaryAction) {
						Button(action: {
							haptic(.buttonPress)
							isMarkingAsDone.toggle()
						}) {
							Label { Text("contextMenu.task.markAsDone") } icon: { SFSymbols.checkmark }
						}
					}
				}

				ToolbarItemGroup(placement: .secondaryAction) {
					Button(action: {
						haptic(.buttonPress)
						isShowingEdit.toggle()
					}) {
						Label { Text("contextMenu.task.edit") } icon: { SFSymbols.pencilSquare }
					}

					Button(role: .destructive) {
						haptic(.notification(.warning))
						isDeletingTask.toggle()
					} label: {
						Label { Text("contextMenu.task.delete") } icon: { SFSymbols.trash }
					}
				}
			}
			.alert("taskDetail.alert.markAsDone", isPresented: $isMarkingAsDone, actions: {
				Button("contextMenu.cancel", role: .cancel, action: { haptic(.buttonPress) })
				Button("contextMenu.ok", action: {
					vm.markTaskAsDone()
					dismissThisView()
					haptic(.notification(.success))
				})
			})
			.alert("taskDetail.alert.deleteTask", isPresented: $isDeletingTask, actions: {
				Button("contextMenu.cancel", role: .cancel, action: { haptic(.buttonPress) })
				Button("contextMenu.ok", action: {
					vm.deleteTask()
					dismissThisView()
					haptic(.notification(.success))
				})
			})
			.sheet(isPresented: $isShowingEdit) {
				DetailView.EditMode(vm: self.vm)
			}
		}
	}
}
