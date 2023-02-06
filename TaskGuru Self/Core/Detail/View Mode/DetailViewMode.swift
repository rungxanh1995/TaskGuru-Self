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
					LazyVGrid(columns: columns) {
						DetailGridCell(title: vm.task.name, caption: "Name")
						DetailGridCell(title: vm.task.status.rawValue, caption: "Status", titleColor: vm.task.colorForStatus())
						DetailGridCell(title: vm.task.numericDueDate, caption: "Due date", titleColor: vm.task.colorForDueDate())
						DetailGridCell(title: vm.task.type.rawValue, caption: "Type")
					}

					if vm.task.notes.isEmpty == false {
						DetailGridCell(title: vm.task.notes, caption: "Notes")
					}
				}
				.padding()

				Text("Last updated on \(vm.task.formattedLastUpdated)")
					.font(.system(.caption, design: .rounded))
					.foregroundColor(.secondary)
					.padding([.bottom])
			}
			.navigationTitle("Task Detail")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				// swiftlint:disable multiple_closures_with_trailing_closure
				if vm.taskIsNewOrInProgress {
					ToolbarItemGroup(placement: .primaryAction) {
						Button(action: {isMarkingAsDone.toggle()}) {
							Label("Mark as Done", systemImage: "checkmark")
						}
					}
				}

				ToolbarItemGroup(placement: .secondaryAction) {
					Button(action: {
						isShowingEdit.toggle()
						haptic(.success)
					}) {
						Label("Edit", systemImage: "square.and.pencil")
					}

					Button(action: {
						isDeletingTask.toggle()
						haptic(.warning)
					}) {
						Label("Delete", systemImage: "trash")
					}
				}
			}
			.alert("Mark Task as Done?", isPresented: $isMarkingAsDone, actions: {
				Button("Cancel", role: .cancel, action: {})
				Button("OK", action: {
					vm.markTaskAsDone()
					dismissThisView()
					haptic(.success)
				})
			})
			.alert("Delete Task?", isPresented: $isDeletingTask, actions: {
				Button("Cancel", role: .cancel, action: {})
				Button("OK", action: {
					vm.deleteTask()
					dismissThisView()
					haptic(.success)
				})
			})
			.sheet(isPresented: $isShowingEdit) {
				DetailView.EditMode(vm: self.vm)
			}
		}
	}
}
