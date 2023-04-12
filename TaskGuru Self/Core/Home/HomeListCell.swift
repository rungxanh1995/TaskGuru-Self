//
//  HomeListCell.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

struct HomeListCell: View {
	@ObservedObject var task: TaskItem
	@Preference(\.isRelativeDateTime) private var isRelativeDateTime
	@Preference(\.isTodayDuesHighlighted) private var isCellHighlighted
	@Environment(\.dynamicTypeSize) var dynamicTypeSize

	private let columns = [
		GridItem(.flexible(), alignment: .leading),
		GridItem(.flexible(), alignment: .leading),
		GridItem(.flexible(), alignment: .leading)
	]

	var body: some View {
		let lowerLayout = dynamicTypeSize <= .xxLarge ?
		AnyLayout(HStackLayout(alignment: .center)) :
		AnyLayout(VStackLayout(alignment: .leading))

		VStack(alignment: .leading) {
			HStack(alignment: .top) {
				if task.priority != .none { taskPriority }
				taskName
			}
			.bold(task.isNotDone ? true : false)

			lowerLayout {
				taskStatus.padding(.trailing, 12)
				taskDueDate.padding(.trailing, 12)
				taskType
			}
		}
		.strikethrough(task.isNotDone ? false : true)
		.disableDefaultAccessibilityBehavior()
		.accessibilityElement(children: .combine)
		.accessibilityValue(accessibilityString)
	}
}

extension HomeListCell {
	private var taskStatus: some View {
		Label {
			Text(LocalizedStringKey(task.status.rawValue))
		} icon: {
			ZStack {
				switch task.status {
				case .new: SFSymbols.sparkles
				case .inProgress: SFSymbols.circleArrows
				case .done: SFSymbols.checkmark
				}
			}.font(.caption)
		}
		.labelStyle(.titleAndIcon)
		.font(.subheadline)
		.if(task.isNotDone) { dueDate in
			dueDate.if(isCellHighlighted) { status in
				// intentional accessibility decision
				status.foregroundColor(.primary)
			} elseCase: { status in
				status.foregroundColor(task.colorForStatus())
			}
		} elseCase: { status in
			status.foregroundColor(.secondary)
		}
	}

	private var taskPriority: some View {
		DynamicColorLabel {
			Label {
				Text(LocalizedStringKey(task.priority.rawValue))
			} icon: {
				ZStack {
					switch task.priority {
					case .none: EmptyView()
					default: Text(task.priority.visualized)
					}
				}
			}
			.labelStyle(.iconOnly)
		}
		.font(.body)
		.tint(task.isNotDone ? nil : .secondary)
	}

	private var taskName: some View {
		Text(task.name)
			.font(.body)
			.foregroundColor(task.isNotDone ? nil : .secondary)
			.lineLimit(2).truncationMode(.tail)
	}

	private var taskType: some View {
		Label {
			Text(LocalizedStringKey(task.type.rawValue))
		} icon: {
			ZStack {
				switch task.type {
				case .personal: SFSymbols.personFilled
				case .work: SFSymbols.buildingFilled
				case .school: SFSymbols.graduationCapFilled
				case .coding: SFSymbols.computer
				default: SFSymbols.listFilled
				}
			}.font(.caption)
		}
		.labelStyle(.titleAndIcon)
		.font(.subheadline)
		.foregroundColor(task.isNotDone ? nil : .secondary)
	}

	private var taskDueDate: some View {
		Label {
			Text(isRelativeDateTime ? task.relativeDueDate : task.shortDueDate)
		} icon: {
			SFSymbols.alarm.font(.caption)
		}
		.labelStyle(.titleAndIcon)
		.font(.subheadline)
		.if(task.isNotDone) { dueDate in
			dueDate.if(isCellHighlighted) { dueDate in
				// intentional accessibility decision
				dueDate.foregroundColor(.primary)
			} elseCase: { dueDate in
				dueDate.foregroundColor(task.colorForDueDate())
			}
		} elseCase: { dueDate in
			dueDate.foregroundColor(.secondary)
		}
	}
}

extension HomeListCell {
	private var accessibilityString: String {
		var accessibilityString = ""
		accessibilityString.append("Task name: \(task.name),")
		accessibilityString.append("\(task.priority.accessibilityString) priority,")
		accessibilityString.append("\(task.status.accessibilityString) status,")
		accessibilityString.append(isRelativeDateTime ? "Due \(task.relativeDueDate)," : "Due on \(task.shortDueDate),")
		accessibilityString.append("\(task.type.accessibilityString) type.")
		return accessibilityString
	}
}

struct HomeListCell_Previews: PreviewProvider {
	static var previews: some View {
		HomeListCell(task: dev.task)
	}
}
