//
//  EditView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

extension DetailView {
	struct EditMode: View {
		internal enum FocusField { case name, notes }
		
		@FocusState
		private var focusField: FocusField?
		
		@Environment(\.dismiss) var dismissThisView
		
		@ObservedObject
		var vm: DetailView.ViewModel
		
		var body: some View {
			NavigationView {
				Form {
					Section {
						TextField("Name", text: $vm.task.name)
							.focused($focusField, equals: .name)
						
						DatePicker("Due Date", selection: $vm.task.dueDate,
								   in: TaskConstants.dateRangeFromToday,
								   displayedComponents: .date
						)
						
						Picker("Type", selection: $vm.task.type) {
							ForEach(TaskConstants.allTypes, id: \.self) {
								Text($0.rawValue)
							}
						}
						
						Picker("Status", selection: $vm.task.status) {
							ForEach(TaskConstants.allStatuses, id: \.self) {
								Text($0.rawValue)
							}
						}
					} header: {
						HStack {
							SFSymbols.gridFilled
							Text("General")
						}
					}
					
					Section {
						TextField("Notes", text: $vm.task.notes, prompt: Text("Any extra notes..."), axis: .vertical)
							.focused($focusField, equals: .notes)

					} header: {
						HStack {
							SFSymbols.pencilDrawing
							Text("Notes")
						}
					}
				}
				.onSubmit { focusField = nil }
				.navigationTitle("Edit Task")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("Cancel") {
							dismissThisView()
						}
					}
					
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Save") {
							didTapSaveButton()
						}
						.font(.headline)
					}
				}
			}
		}
		
		private func didTapSaveButton() -> Void {
			vm.updateItemInItsSource()
			dismissThisView()
		}
	}
}