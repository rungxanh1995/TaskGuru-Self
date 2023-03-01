//
//  SettingsIcon.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-23.
//

import SwiftUI

struct SettingsIcon: View {
	let icon: Image
	let accent: Color

	var body: some View {
		VStack {
			icon
				.resizable()
				.scaledToFit()
				.frame(width: 20, height: 20)
		}
		.background(in: RoundedRectangle(cornerRadius: 3).inset(by: -4))
		.backgroundStyle(accent.opacity(0.25))
		.foregroundStyle(accent)
		.padding(4)
	}
}

struct SettingsIcon_Previews: PreviewProvider {
	static var previews: some View {
		SettingsIcon(icon: SFSymbols.paintbrush, accent: .pink)
			.previewLayout(.sizeThatFits)
	}
}
