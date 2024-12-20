//
//  DetailViewMode.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

extension DetailScreen {
	struct ViewMode: View {
		@ObservedObject var vm: DetailScreen.ViewModel

		@Environment(\.dismiss) var dismissThisView
		@Environment(\.displayScale) var displayScale

		@State private var isShowingEdit: Bool = false
		@State private var isMarkingAsDone: Bool = false
		@State private var isDeletingTask: Bool = false

		private let columns = [
			GridItem(.flexible(minimum: 120.0, maximum: 600.0)),
			GridItem(.flexible(minimum: 120.0, maximum: 600.0))
		]

		var body: some View {
			ScrollView {
				details
			}
			.navigationTitle("taskDetail.nav.title")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					ShareLink(item: Image(uiImage: taskSnapshot),
										preview: SharePreview(vm.task.name, image: Image(uiImage: taskSnapshot)))
				}

				ToolbarItemGroup(placement: .secondaryAction) {
					if vm.task.isNotDone {
						Button {
							haptic(.buttonPress)
							isMarkingAsDone.toggle()
						} label: {
							Label { Text("contextMenu.task.markDone") } icon: { SFSymbols.checkmark }
						}
					}

					Button {
						haptic(.buttonPress)
						isShowingEdit.toggle()
					} label: {
						Label { Text("contextMenu.task.edit") } icon: { SFSymbols.pencilSquare }
					}

					Button(role: .destructive) {
						haptic(.notification(.warning))
						isDeletingTask.toggle()
					} label: {
						Label { Text("contextMenu.task.delete") } icon: { SFSymbols.trash }
					}
				}
			}
			.alert("taskDetail.alert.markAsDone", isPresented: $isMarkingAsDone, actions: {
				Button("contextMenu.cancel", role: .cancel) {
					haptic(.buttonPress)
				}
				Button("contextMenu.ok") {
					vm.markTaskAsDone()
					dismissThisView()
					haptic(.notification(.success))
				}
			})
			.alert("taskDetail.alert.deleteTask", isPresented: $isDeletingTask) {
				Button("contextMenu.cancel", role: .cancel) {
					haptic(.buttonPress)
				}
				Button("contextMenu.ok") {
					vm.deleteTask()
					dismissThisView()
					haptic(.notification(.success))
				}
			}
			.sheet(isPresented: $isShowingEdit) {
				DetailScreen.EditMode(vm: self.vm)
			}
		}

		private var details: some View {
			VStack {
				VStack(spacing: 8) {
					DetailGridCell(title: vm.task.name, caption: "taskDetail.cell.name.caption")

					LazyVGrid(columns: columns) {
						DetailGridCell(title: vm.task.priority.rawValue, caption: "taskDetail.cell.priority.caption",
													 titleColor: vm.task.colorForPriority())
						DetailGridCell(title: vm.task.status.rawValue, caption: "taskDetail.cell.status.caption",
													 titleColor: vm.task.colorForStatus())
						DetailGridCell(title: vm.task.numericDueDate, caption: "taskDetail.cell.dueDate.caption",
													 titleColor: vm.task.colorForDueDate())
						DetailGridCell(title: vm.task.type.rawValue, caption: "taskDetail.cell.type.caption")
					}

					if vm.task.notes.isEmpty == false {
						DetailGridCell(title: vm.task.notes, caption: "taskDetail.cell.notes.caption")
					}
				}
				.padding()

				Text("Last updated at \(vm.task.formattedLastUpdated)")
					.font(.footnote)
					.foregroundColor(.secondary)
					.padding([.bottom])
			}
		}

		@MainActor private var taskSnapshot: UIImage {
			let renderer = ImageRenderer(content: details)
			renderer.scale = displayScale
			// Convert image to JPEG, otherwise you'll encounter issues with transparency
			guard let image = renderer.uiImage,
						let jpegData = image.jpegData(compressionQuality: 1.0),
						let jpegImage = UIImage(data: jpegData) else {
				return UIImage()
			}
			return jpegImage
		}
	}
}
