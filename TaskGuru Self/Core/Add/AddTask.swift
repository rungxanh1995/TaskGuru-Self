//
//  AddTask.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct AddTask: View {
	internal enum FocusField { case name, notes }

	@FocusState
	private var focusField: FocusField?

	@Environment(\.dismiss) var dismissThisView

	@ObservedObject
	var vm: AddTask.ViewModel

    var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Name", text: $vm.taskName)
						.focused($focusField, equals: .name)

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
						SFSymbols.gridFilled
						Text("General")
					}
				}

				Section {
					TextField("Notes", text: $vm.taskNotes,
							  prompt: Text("Any extra notes..."),
							  axis: .vertical)
					.focused($focusField, equals: .notes)
				} header: {
					HStack {
						SFSymbols.pencilDrawing
						Text("Notes")
					}
				}
			}
			.onSubmit { focusField = nil }
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
		.interactiveDismissDisabled()
    }
}

extension AddTask {
	private func addNewTask() {
		vm.addNewTask()
		haptic(.success)
	}
}

struct AddTask_Previews: PreviewProvider {
    static var previews: some View {
		AddTask(vm: .init(parentVM: dev.homeVM))
    }
}
