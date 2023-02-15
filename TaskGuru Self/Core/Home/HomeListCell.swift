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
			VStack(alignment: .leading, spacing: 4) {
				taskName
				taskType
			}

			Spacer()

			VStack(alignment: .trailing, spacing: 4) {
				taskDueDate
				taskStatus
			}
		}
	}
}

extension HomeListCell {
	private var taskName: some View {
		Text(task.name)
			.font(.system(.body))
	}

	private var taskType: some View {
		HStack(spacing: 4) {
			Group {
				switch task.type {
				case .personal: SFSymbols.personFilled
				case .work: SFSymbols.buildingFilled
				case .school: SFSymbols.graduationCapFilled
				default: SFSymbols.listFilled
				}
			}
			.font(.system(.caption2))

			Text(LocalizedStringKey(task.type.rawValue))
		}
		.font(.system(.subheadline))
		.foregroundColor(.secondary)
	}

	private var taskDueDate: some View {
		HStack(spacing: 6) {
			SFSymbols.calendarWithClock.font(.callout)
			Text(task.shortDueDate)
		}
		.font(.system(.body))
		.foregroundColor(task.colorForDueDate())
	}

	private var taskStatus: some View {
		HStack(spacing: 4) {
			Group {
				switch task.status {
				case .new: SFSymbols.sparkles
				case .inProgress: SFSymbols.circleArrows
				case .done: SFSymbols.checkmark
				}
			}
			.font(.system(.caption2))

			Text(LocalizedStringKey(task.status.rawValue))
		}
		.font(.system(.subheadline))
		.foregroundColor(task.colorForStatus())
	}
}

struct HomeListCell_Previews: PreviewProvider {
    static var previews: some View {
		HomeListCell(task: dev.task)
	}
}
