//
//  HomeListCell.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

struct HomeListCell: View {
	let task: TaskItem
	
    var body: some View {
		HStack(alignment: .top) {
			VStack(alignment: .leading, spacing: 8) {
				Text(task.name)
					.font(.system(.headline, design: .rounded))
			}
			
			Spacer()
			
			VStack(alignment: .trailing, spacing: 8) {
				Text("Due \(task.numericDueDate)")
					.font(.system(.callout, design: .rounded))
					.foregroundColor(task.colorForDueDate())
				
				HStack(spacing: 4) {
					statusIcon
					Text(task.status.rawValue)
				}
				.font(.system(.caption, design: .rounded))
				.foregroundColor(task.colorForStatus())
			}
			
		}
    }
}


private extension HomeListCell {
	
	@ViewBuilder
	var statusIcon: Image {
		Image(systemName: "circle.fill")
			.symbolRenderingMode(.hierarchical)
	}
}

struct HomeListCell_Previews: PreviewProvider {
    static var previews: some View {
		HomeListCell(task: dev.task)
	}
}
