//
//  SettingsIcon.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-23.
//

import SwiftUI

struct SettingsIcon: View {
	let icon: Image
	let bgColor: Color

	var body: some View {
		VStack {
			icon
				.resizable()
				.scaledToFit()
				.frame(width: 20, height: 20)
		}
		.background(in: RoundedRectangle(cornerRadius: 3).inset(by: -4))
		.backgroundStyle(bgColor)
		.foregroundStyle(.white.shadow(.drop(radius: 1, y: 1.5)))
		.padding(4)
	}
}

struct SettingsIcon_Previews: PreviewProvider {
	static var previews: some View {
		SettingsIcon(icon: SFSymbols.palette, bgColor: .pink)
			.previewLayout(.sizeThatFits)
	}
}
