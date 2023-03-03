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
		@EnvironmentObject var appState: AppState
		@Environment(\.dismiss) var dismissThisView

		@ObservedObject var vm: DetailView.ViewModel

		var body: some View {
			NavigationView {
				Form {
					Section {
						TextField("editTask.input.name", text: $vm.taskName)
							.focused($focusField, equals: .name)

						DatePicker("editTask.input.dueDate", selection: $vm.taskDueDate,
								   displayedComponents: .date
						)

						Picker("editTask.input.type", selection: $vm.taskType) {
							ForEach(TaskType.allCases, id: \.self) {
								Text(LocalizedStringKey($0.rawValue))
							}
						}

						Picker("editTask.input.status", selection: $vm.taskStatus) {
							ForEach(TaskStatus.allCases, id: \.self) {
								Text(LocalizedStringKey($0.rawValue))
							}
						}

						Picker("editTask.input.priority", selection: $vm.taskPriority) {
							ForEach(TaskPriority.allCases, id: \.self) {
								Text(LocalizedStringKey($0.rawValue))
							}
						}
					} header: {
						Label {
							Text("editTask.sections.general")
						} icon: {
							SFSymbols.gridFilled
						}
					}

					Section {
						TextField("editTask.input.notes", text: $vm.taskNotes,
											prompt: Text("editTask.input.placeholder.notes"),
											axis: .vertical)
							.focused($focusField, equals: .notes)

					} header: {
						Label {
							Text("editTask.sections.notes")
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
				.navigationTitle("editTask.nav.title")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .cancellationAction) {
						Button("editTask.nav.button.cancel") {
							haptic(.buttonPress)
							dismissThisView()
						}
					}

					ToolbarItem(placement: .confirmationAction) {
						Button("editTask.nav.button.save") {
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
			dismissThisView()
			appState.popToRoot()
			haptic(.notification(.success))
		}
	}
}
