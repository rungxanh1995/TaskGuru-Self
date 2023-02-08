//
//  EditView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

extension DetailView {
	struct EditMode: View {
		// swiftlint:disable nesting
		internal enum FocusField { case name, notes }

		@FocusState private var focusField: FocusField?

		/// Needs this here, so we can navigate back to `Home` view after editing.
		/// Otherwise, we would see that the task info is not re-rendered in Detail View mode.
		@EnvironmentObject private var appState: AppState
		@Environment(\.dismiss) var dismissThisView

		@ObservedObject var vm: DetailView.ViewModel

		var body: some View {
			NavigationView {
				Form {
					Section {
						TextField("Name", text: $vm.taskName)
							.focused($focusField, equals: .name)

						DatePicker("Due Date", selection: $vm.taskDueDate,
								   in: TaskConstants.dateRangeFromToday,
								   displayedComponents: .date
						)

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
						TextField("Notes", text: $vm.taskNotes, prompt: Text("Any extra notes..."), axis: .vertical)
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
			.interactiveDismissDisabled()
		}

		private func didTapSaveButton() {
			vm.updateTask()
			haptic(.success)
			dismissThisView()
			appState.popToRoot()
		}
	}
}
