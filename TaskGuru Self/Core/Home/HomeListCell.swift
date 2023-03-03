//
//  HomeListCell.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

struct HomeListCell: View {
	@ObservedObject var task: TaskItem

	var body: some View {
		HStack(alignment: .top) {
			HStack {
				taskStatus
				taskName
			}

			Spacer(minLength: 8.0)

			VStack(alignment: .trailing, spacing: 4) {
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
		.font(.body)
		.frame(width: 18, height: 18)
		.clipShape(RoundedRectangle(cornerRadius: 9*(18/40)))
		.background(in: RoundedRectangle(cornerRadius: 3).inset(by: -4))
		.backgroundStyle(task.colorForStatus().opacity(0.25))
		.foregroundStyle(task.colorForStatus())
		.padding(4)
	}

	private var taskName: some View {
		Text(task.name)
			.font(.system(.body))
			.strikethrough(task.isNotDone ? false : true)
			.foregroundColor(task.isNotDone ? nil : .gray)
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
			.font(.system(.caption2))

			Text(LocalizedStringKey(task.type.rawValue))
		}
		.font(.system(.subheadline))
		.strikethrough(task.isNotDone ? false : true)
		.foregroundColor(.secondary)
	}

	private var taskDueDate: some View {
		HStack(spacing: 6) {
			SFSymbols.alarm.font(.callout)
			Text(task.shortDueDate)
		}
		.font(.subheadline)
		.strikethrough(task.isNotDone ? false : true)
		.foregroundColor(task.isNotDone ? task.colorForDueDate() : .gray)
	}
}

struct HomeListCell_Previews: PreviewProvider {
    static var previews: some View {
		HomeListCell(task: dev.task)
	}
}
