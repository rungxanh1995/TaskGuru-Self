//
//  HomeListCell.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

struct HomeListCell: View {
	@ObservedObject var task: TaskItem

	private let columns = [
		GridItem(.fixed(60), alignment: .leading),
		GridItem(.flexible(), alignment: .leading),
		GridItem(.flexible(), alignment: .leading)
	]

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			HStack(alignment: .top) {
				if task.priority != .none { taskPriority }
				taskName
			}
			.bold(task.isNotDone ? true : false)

			LazyVGrid(columns: columns) {
				taskStatus
				taskDueDate
				taskType
			}
		}
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
			}
		}
		.labelStyle(.iconOnly)
		.font(.caption)
		.foregroundStyle(task.colorForStatus())
	}

	private var taskPriority: some View {
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
		.font(.body)
		.strikethrough(task.isNotDone ? false : true)
		.foregroundColor(task.isNotDone ? task.colorForPriority() : .secondary)
	}

	private var taskName: some View {
		Text(task.name)
			.font(.body)
			.strikethrough(task.isNotDone ? false : true)
			.foregroundColor(task.isNotDone ? nil : .secondary)
			.lineLimit(2).truncationMode(.tail)
	}

	private var taskType: some View {
		Label {
			Text(LocalizedStringKey(task.type.rawValue))
		} icon: {
			Group {
				switch task.type {
				case .personal: SFSymbols.personFilled
				case .work: SFSymbols.buildingFilled
				case .school: SFSymbols.graduationCapFilled
				case .coding: SFSymbols.computer
				default: SFSymbols.listFilled
				}
			}
			.font(.caption)
		}
		.labelStyle(.titleAndIcon)
		.font(.subheadline)
		.strikethrough(task.isNotDone ? false : true)
		.foregroundColor(task.isNotDone ? nil : .secondary)
	}

	private var taskDueDate: some View {
		Label {
			Text(task.shortDueDate)
		} icon: {
			SFSymbols.alarm.font(.caption)
		}
		.labelStyle(.titleAndIcon)
		.font(.subheadline)
		.strikethrough(task.isNotDone ? false : true)
		.foregroundColor(task.isNotDone ? task.colorForDueDate() : .secondary)
	}
}

struct HomeListCell_Previews: PreviewProvider {
	static var previews: some View {
		HomeListCell(task: dev.task)
	}
}
