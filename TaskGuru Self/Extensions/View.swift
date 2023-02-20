//
//  View.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

extension View {
	/// Applies the given transform if the given condition evaluates to `true`.
	///
	/// Tutorial link: https://www.avanderlee.com/swiftui/conditional-view-modifier/
	/// Consideration: https://www.objc.io/blog/2021/08/24/conditional-view-modifiers/
	/// - Parameters:
	///   - condition: The condition to evaluate.
	///   - transform: The transform to apply to the source `View`.
	/// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
	@ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
		if condition { transform(self) } else { self }
	}

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
				.saturation(0)
				.frame(width: 200, height: 200)
			Spacer()
		}
	}

	/// Configure the font design of this application.
	func setUpFontDesign() -> some View {
		modifier(FontDesignModifier())
	}

	/// Configure the tinted accent color of this application.
	func setUpAccentColor() -> some View {
		modifier(AccentColorModifier())
	}
}
