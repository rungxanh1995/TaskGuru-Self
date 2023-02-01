//
//  DetailView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct DetailView: View {
	let task: TaskItem
	
	@State private var isShowingEdit: Bool = false
	@State private var isMarkingAsDone: Bool = false
	@State private var isDeletingTask: Bool = false
	
	private let columns = [
		GridItem(.adaptive(minimum: 150.0, maximum: 200.0))
	]
	
    var body: some View {
		ScrollView {
			VStack(spacing: 8) {
				LazyVGrid(columns: columns) {
					DetailGridCell(title: task.name, caption: "Name")
					DetailGridCell(title: task.status.rawValue, caption: "Status", titleColor: task.colorForStatus())
					DetailGridCell(title: task.numericDueDate, caption: "Due date", titleColor: task.colorForDueDate())
					DetailGridCell(title: task.type.rawValue, caption: "Type")
				}
				
				if task.notes.isEmpty == false {
					DetailGridCell(title: task.notes, caption: "Notes")
				}
			}
			.padding([.horizontal, .bottom])
			
			Text("Last updated on 2023-01-29")
				.font(.system(.caption))
				.foregroundColor(.secondary)
		}
		.navigationTitle("Task Detail")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItemGroup(placement: .primaryAction) {
				Button {
					isMarkingAsDone.toggle()
				} label: {
					Label("Mark as Done", systemImage: "checkmark")
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
				// code here to mark task as done...
			})
		})
		.alert("Delete Task?", isPresented: $isDeletingTask, actions: {
			Button("Cancel", role: .cancel, action: {})
			Button("OK", action: {
				// code here to delete selected task...
			})
		})
		.sheet(isPresented: $isShowingEdit) {
			EditView()
		}
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			DetailView(task: TaskItem.mockData.first!)
		}
    }
}
