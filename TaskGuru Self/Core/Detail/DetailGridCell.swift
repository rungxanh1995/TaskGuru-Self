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
			Text(title)
				.font(.system(.headline, design: .rounded).bold())
				.multilineTextAlignment(.center)
				.padding()
				.foregroundColor(titleColor)
			
			Spacer()
			
			Text(caption)
				.font(.system(.caption, design: .rounded))
				.padding(6)
				.frame(maxWidth: .infinity)
				.background(.thickMaterial)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(.thinMaterial)
		.clipShape(RoundedRectangle(cornerRadius: 8))
		
    }
}

struct DetailGridCell_Previews: PreviewProvider {
    static var previews: some View {
        DetailGridCell(title: "Todo name", caption: "Name")
    }
}
