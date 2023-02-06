//
//  View.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

extension View {
	/// Configure the color theme of this application.
	func setUpColorTheme() -> some View {
		modifier(SchemeModifier())
	}
	
	func makeCheerfulDecorativeImage() -> some View {
		HStack {
			Spacer()
			Image("happy-sun")
				.resizable()
				.scaledToFit()
				.frame(width: 200, height: 200)
			Spacer()
		}
	}
}
