//
//  DetailView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct DetailView: View {
	let task: String
	
	let columns = [
		GridItem(.adaptive(minimum: 150.0, maximum: 180.0))
	]
	
    var body: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				DetailGridCell(title: "Todo name", caption: "Name")
				DetailGridCell(title: "Lorem ipsum amba", caption: "Notes")
				DetailGridCell(title: "In Progress", caption: "Status", titleColor: .orange)
				DetailGridCell(title: "2023-03-01", caption: "Due date", titleColor: .mint)
				DetailGridCell(title: "Personal", caption: "Type")
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
				Button(action: {}) {
					Label("Edit", systemImage: "square.and.pencil")
				}
				
				Button(action: {}) {
					Label("Delete", systemImage: "trash")
				}
			}
		}
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			DetailView(task: "Do chores")
		}
    }
}
