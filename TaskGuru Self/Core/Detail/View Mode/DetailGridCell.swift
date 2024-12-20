//
//  DetailGridCell.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct DetailGridCell: View {
	let title: String
	let caption: LocalizedStringKey
	var titleColor: Color = .primary

	var body: some View {
		VStack {
			Text(LocalizedStringKey(title))
				.font(.headline)
				.multilineTextAlignment(.center)
				.padding()
				.frame(maxWidth: .infinity)
				.foregroundColor(titleColor)
				.textSelection(.enabled)

			Spacer()

			Text(caption)
				.font(.caption)
				.padding(6)
				.frame(maxWidth: .infinity)
				.overlay(
					Rectangle()
						.fill(.gray.opacity(0.25).gradient)
				)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.clipShape(RoundedRectangle(cornerRadius: 8))
		.overlay(
			RoundedRectangle(cornerRadius: 8)
				.stroke(.gray.opacity(0.5), lineWidth: 0.5)
		)
	}
}

struct DetailGridCell_Previews: PreviewProvider {
	static var previews: some View {
		DetailGridCell(title: "Todo name", caption: "Name")
	}
}
