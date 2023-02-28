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
					TextField("addTask.input.name", text: $vm.taskName)
						.focused($focusField, equals: .name)

					DatePicker("addTask.input.dueDate", selection: $vm.dueDate, displayedComponents: .date)

					Picker("addTask.input.type", selection: $vm.taskType) {
						ForEach(TaskConstants.allTypes, id: \.self) {
							Text(LocalizedStringKey($0.rawValue))
						}
					}

					Picker("addTask.input.status", selection: $vm.taskStatus) {
						ForEach(TaskConstants.allStatuses, id: \.self) {
							Text(LocalizedStringKey($0.rawValue))
						}
					}
				} header: {
					Label {
						Text("addTask.sections.general")
					} icon: {
						SFSymbols.gridFilled
					}
				}

				Section {
					TextField("addTask.input.notes", text: $vm.taskNotes,
							  prompt: Text("addTask.input.placeholder.notes"),
							  axis: .vertical)
					.focused($focusField, equals: .notes)
				} header: {
					Label {
						Text("addTask.sections.notes")
					} icon: {
						SFSymbols.gridFilled
					}
				}
			}
			.onAppear {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					focusField = .name
				}
			}
			.onSubmit { focusField = nil }
			.navigationTitle("addTask.nav.title")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("addTask.nav.button.cancel") {
						haptic(.buttonPress)
						dismissThisView()
					}
				}

				ToolbarItem(placement: .confirmationAction) {
					Button("addTask.nav.button.add", action: {
						addNewTask()
						dismissThisView()
					})
				}
			}
		}
		.interactiveDismissDisabled()
	}
}

extension AddTask {
	private func addNewTask() {
		vm.addNewTask()
		haptic(.notification(.success))
	}
}

struct AddTask_Previews: PreviewProvider {
    static var previews: some View {
		AddTask(vm: .init(parentVM: dev.homeVM))
	}
}
