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

	/// Applies the given transform if the given condition evaluates to `true`, otherwise you can set an `else` case.
	///
	/// Tutorial link: https://medium.com/swiftui-made-easy/context-menu-with-preview-in-swiftui-242eab7b9375
	/// Consideration: https://www.objc.io/blog/2021/08/24/conditional-view-modifiers/
	/// - Parameters:
	///   - condition: The condition to evaluate.
	///   - ifContent: The transform to apply to the source `View` when condition is true.
	///   - elseContent: The transform to apply to the source `View` when condition is false.
	/// - Returns: The modified `View` dependent on whether conditon is `true` or `false`.
	@ViewBuilder func `if`<TrueContent: View, FalseContent: View>(
		_ condition: Bool,
		@ViewBuilder ifCase ifContent: (Self) -> TrueContent,
		@ViewBuilder elseCase elseContent: (Self) -> FalseContent
	) -> some View {
		if condition { ifContent(self) } else { elseContent(self) }
	}

	@ViewBuilder
	func ifLet<Value, Content: View>(_ value: Value?, @ViewBuilder content: (Self, Value) -> Content) -> some View {
		if let value = value { content(self, value) } else { self }
	}

	/// Configure the color theme of this application.
	func setUpColorTheme() -> some View {
		modifier(SchemeModifier())
	}

	func makeCheerfulDecorativeImage() -> some View {
		HStack {
			Spacer()
			Image("cheerful12")
				.resizable()
				.scaledToFill()
				.saturation(0)
				.frame(maxWidth: 300, maxHeight: 240)
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

	func playConfetti(_ confettiCounter: Binding<Int>) -> some View {
		modifier(ConfettiViewModifier(counter: confettiCounter))
	}
}
