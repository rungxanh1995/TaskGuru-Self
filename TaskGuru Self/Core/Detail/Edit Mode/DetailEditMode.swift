//
//  EditView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

extension DetailView {
	struct EditMode: View {
		@Environment(\.dismiss) var dismissThisView
		
		@ObservedObject
		var vm: DetailView.ViewModel
		
		var body: some View {
			NavigationView {
				Form {
					Section {
						TextField("Name", text: $vm.task.name)
						
						DatePicker("Due Date", selection: $vm.task.dueDate,
								   in: TaskConstants.dateRangeFromToday,
								   displayedComponents: .date
						)
						
						Picker("Status", selection: $vm.task.status) {
							ForEach(TaskConstants.allStatuses, id: \.self) {
								Text($0.rawValue)
							}
						}
					} header: {
						HStack {
							Image(systemName: "square.fill.text.grid.1x2")
							Text("General")
						}
					}
					
					Section {
						TextField("Notes", text: $vm.task.notes, prompt: Text("Any extra notes..."), axis: .vertical)
					} header: {
						HStack {
							Image(systemName: "pencil.and.outline")
							Text("Notes")
						}
					}
				}
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
