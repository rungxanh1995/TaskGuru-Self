//
//  AddTask.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct AddTask: View {
	@Environment(\.dismiss) var dismissThisView
	
	@State
	private var taskName: String = ""
	
	private let taskTypes = ["Personal", "Work", "School"]
	@State
	private var taskTypeSelected = "Personal"
	
	@State
	private var dueDate: Date = .init()
	let dateRangeFromToday: PartialRangeFrom<Date> = Date()...
	
	@State
	private var statusSelected = "New"
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
					
					Picker("Type", selection: $taskTypeSelected) {
						ForEach(taskTypes, id: \.self) {
							Text($0)
						}
					}
					
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
			.navigationTitle("Add Task")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Cancel") {
						dismissThisView()
					}
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Add") {
						// add task then dismiss view
					}
					.font(.headline)
				}
			}
		}
    }
}

struct AddTask_Previews: PreviewProvider {
    static var previews: some View {
        AddTask()
    }
}
