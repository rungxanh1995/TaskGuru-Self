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
		icon
			.resizable()
			.scaledToFit()
			.frame(width: 21.75, height: 21.75)
			.background(in: RoundedRectangle(cornerRadius: 4).inset(by: -4))
			.backgroundStyle(accent)
			.foregroundStyle(.white)
			.padding(4)
			.overlay(
				RoundedRectangle(cornerRadius: 8)
					.stroke(.gray.opacity(0.25), lineWidth: 0.5)
			)
	}
}

struct SettingsIcon_Previews: PreviewProvider {
	static var previews: some View {
		SettingsIcon(icon: SFSymbols.paintbrush, accent: .pink)
			.previewLayout(.sizeThatFits)
	}
}
