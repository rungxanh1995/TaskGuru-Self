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
		
		@State
		private var taskName: String = ""
		
		@State
		private var dueDate: Date = .init()
		let dateRangeFromToday: PartialRangeFrom<Date> = Date()...
		
		@State
		private var statusSelected = "In progress"
		private let statuses = ["New", "In progress", "Done"]
		
		@State
		private var taskNotes = ""
		
		var body: some View {
			NavigationView {
				Form {
					Section(header: Text("General")) {
						TextField("Name", text: $taskName)
						
						DatePicker("Due Date", selection: $dueDate,
								   in: dateRangeFromToday,
								   displayedComponents: .date
						)
						
						Picker("Status", selection: $statusSelected) {
							ForEach(statuses, id: \.self) {
								Text($0)
							}
						}
					}
					
					Section(header: Text("Notes")) {
						TextField("Notes", text: $taskNotes, prompt: Text("Any extra notes..."), axis: .vertical)
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
							// add task then dismiss view
							dismissThisView()
						}
						.font(.headline)
					}
				}
			}
		}
	}
}
