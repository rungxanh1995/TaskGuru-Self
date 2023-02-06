//
//  HomeListCell.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

struct HomeListCell: View {
	var task: TaskItem
	
	var body: some View {
		HStack(alignment: .top) {
			VStack(alignment: .leading, spacing: 0) {
				taskName
				taskType
			}
			
			Spacer()
			
			VStack(alignment: .trailing, spacing: 0) {
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
			
			Text(task.type.rawValue)
		}
		.font(.system(.footnote))
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
			SFSymbols.circleFilled.font(.system(.caption2))
			Text(task.status.rawValue)
		}
		.font(.system(.footnote))
		.foregroundColor(task.colorForStatus())
	}
}

struct HomeListCell_Previews: PreviewProvider {
    static var previews: some View {
		HomeListCell(task: dev.task)
	}
}
