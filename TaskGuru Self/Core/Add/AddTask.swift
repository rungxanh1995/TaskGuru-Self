//
//  AddTask.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct AddTask: View {
	@Environment(\.dismiss) var dismissThisView
	
	@ObservedObject
	var vm: AddTask.ViewModel
	
    var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Name", text: $vm.taskName)
					
					DatePicker("Due Date", selection: $vm.dueDate, in: TaskConstants.dateRangeFromToday, displayedComponents: .date)
					
					Picker("Type", selection: $vm.taskType) {
						ForEach(TaskConstants.allTypes, id: \.self) {
							Text($0.rawValue)
						}
					}
					
					Picker("Status", selection: $vm.taskStatus) {
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
					TextField("Notes", text: $vm.taskNotes,
							  prompt: Text("Any extra notes..."),
							  axis: .vertical)
				} header: {
					HStack {
						Image(systemName: "pencil.and.outline")
						Text("Notes")
					}
				}
			}
			.navigationTitle("Add Task")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Cancel") { dismissThisView() }
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Add", action: {
						addNewTask()
						dismissThisView()
					})
					.font(.headline)
				}
			}
		}
    }
}

extension AddTask {
	private func addNewTask() -> Void {
		vm.addTask(name: &vm.taskName, dueDate: vm.dueDate, type: vm.taskType, status: vm.taskStatus, notes: vm.taskNotes)
	}
}

struct AddTask_Previews: PreviewProvider {
    static var previews: some View {
		AddTask(vm: .init(parentVM: dev.homeVM))
    }
}
