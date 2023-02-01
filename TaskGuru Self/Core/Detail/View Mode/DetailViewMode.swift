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
				
		@State
		private var isShowingEdit: Bool = false
		
		@State
		private var isMarkingAsDone: Bool = false
				
		@State
		private var isDeletingTask: Bool = false
		
		private let columns = [
			GridItem(.adaptive(minimum: 150.0, maximum: 200.0))
		]
		
		var body: some View {
			ScrollView {
				VStack(spacing: 8) {
					LazyVGrid(columns: columns) {
						DetailGridCell(title: vm.task.name, caption: "Name")
						DetailGridCell(title: vm.task.status.rawValue, caption: "Status", titleColor: vm.task.colorForStatus())
						DetailGridCell(title: vm.task.shortDueDate, caption: "Due date", titleColor: vm.task.colorForDueDate())
						DetailGridCell(title: vm.task.type.rawValue, caption: "Type")
					}
					
					if vm.task.notes.isEmpty == false {
						DetailGridCell(title: vm.task.notes, caption: "Notes")
					}
					
				}
				.padding([.horizontal, .bottom])
				
				Text("Last updated on 2023-01-29")
					.font(.system(.caption, design: .rounded))
					.foregroundColor(.secondary)
			}
			.navigationTitle("Task Detail")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				if vm.taskIsNewOrInProgress {
					ToolbarItemGroup(placement: .primaryAction) {
						Button(action: {isMarkingAsDone.toggle()}) {
							Label("Mark as Done", systemImage: "checkmark")
						}
					}
				}
				
				ToolbarItemGroup(placement: .secondaryAction) {
					Button(action: { isShowingEdit.toggle() }) {
						Label("Edit", systemImage: "square.and.pencil")
					}
					
					Button(action: { isDeletingTask.toggle() }) {
						Label("Delete", systemImage: "trash")
					}
				}
			}
			.alert("Mark Task as Done?", isPresented: $isMarkingAsDone, actions: {
				Button("Cancel", role: .cancel, action: {})
				Button("OK", action: {
					vm.markTaskAsDone()
					dismissThisView()
				})
			})
			.alert("Delete Task?", isPresented: $isDeletingTask, actions: {
				Button("Cancel", role: .cancel, action: {})
				Button("OK", action: {
					vm.deleteTask()
					dismissThisView()
				})
			})
			.sheet(isPresented: $isShowingEdit) {
				DetailView.EditMode(vm: self.vm)
			}
		}
	}
}
