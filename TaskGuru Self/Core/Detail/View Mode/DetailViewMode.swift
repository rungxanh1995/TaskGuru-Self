//
//  DetailView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

extension DetailView {
	struct ViewMode: View {
		let task: TaskItem
				
		@State
		private var isShowingEdit: Bool = false
		
		private let columns = [
			GridItem(.adaptive(minimum: 150.0, maximum: 180.0))
		]
		
		var body: some View {
			ScrollView {
				VStack(spacing: 8) {
					LazyVGrid(columns: columns) {
						DetailGridCell(title: task.name, caption: "Name")
						DetailGridCell(title: task.status.rawValue, caption: "Status", titleColor: .orange)
						DetailGridCell(title: task.shortDueDate, caption: "Due date", titleColor: .mint)
						DetailGridCell(title: task.type.rawValue, caption: "Type")
					}
					
					if task.notes.isEmpty == false {
						DetailGridCell(title: task.notes, caption: "Notes")
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
				ToolbarItemGroup(placement: .primaryAction) {
					Button {
						// toggle edit view
					} label: {
						Label("Mark as Done", systemImage: "checkmark")
					}
				}
				
				ToolbarItemGroup(placement: .secondaryAction) {
					Button(action: { isShowingEdit.toggle() }) {
						Label("Edit", systemImage: "square.and.pencil")
					}
					
					Button(action: {}) {
						Label("Delete", systemImage: "trash")
					}
				}
			}
			.sheet(isPresented: $isShowingEdit) {
				EditView()
			}
		}
	}
}
