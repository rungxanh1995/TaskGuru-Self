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
		GridItem(.flexible(), alignment: .leading),
		GridItem(.flexible(), alignment: .leading)
	]

	var body: some View {
		HStack {
			taskStatus
			VStack(alignment: .leading, spacing: 4) {
				HStack(alignment: .top) {
					if task.priority != .none { taskPriority.bold() }
					taskName
				}
				LazyVGrid(columns: columns) {
					taskDueDate
					taskType
				}
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
		.font(.body)
		.frame(width: 20, height: 20)
		.clipShape(RoundedRectangle(cornerRadius: 9*(20/40)))
		.background(in: RoundedRectangle(cornerRadius: 3).inset(by: -4))
		.backgroundStyle(task.colorForStatus().opacity(0.15))
		.foregroundStyle(task.colorForStatus())
		.padding(4)
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
		HStack(spacing: 4) {
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

			Text(LocalizedStringKey(task.type.rawValue))
		}
		.font(.subheadline)
		.strikethrough(task.isNotDone ? false : true)
		.foregroundColor(task.isNotDone ? nil : .secondary)
	}

	private var taskDueDate: some View {
		HStack(spacing: 4) {
			SFSymbols.alarm.font(.caption)
			Text(task.shortDueDate)
		}
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
