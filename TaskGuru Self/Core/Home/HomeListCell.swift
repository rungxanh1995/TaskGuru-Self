//
//  HomeListCell.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-31.
//

import Foundation

import SwiftUI

struct HomeListCell: View {
	
	var task: TaskItem
	
	var body: some View {
		HStack(alignment: .top) {
			VStack(alignment: .leading, spacing: 8) {
				Text(task.name)
					.font(.system(.headline, design: .rounded))
				
				HStack(spacing: 4) {
					switch task.type {
						case .personal: SFSymbols.personFilled
						case .work: SFSymbols.buildingFilled
						case .school: SFSymbols.graduationCapFilled
						default: SFSymbols.listFilled
					}
					
					Text(task.type.rawValue)
				}
				.font(.system(.caption, design: .rounded))
				.foregroundColor(.secondary)
			}
			
			Spacer()
			
			VStack(alignment: .trailing, spacing: 8) {
				Text("\(SFSymbols.calendarWithClock) \(task.numericDueDate)")
					.font(.system(.callout, design: .rounded))
					.foregroundColor(task.colorForDueDate())
				
				HStack(spacing: 4) {
					SFSymbols.circleFilled
					Text(task.status.rawValue)
				}
				.font(.system(.caption, design: .rounded))
				.foregroundColor(task.colorForStatus())
			}
			
		}
	}
}
