//
//  DynamicHighlightBackground.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 14/3/23.
//

import SwiftUI

/// A dynamic view that changes the color to the accent color selected by the user in settings.
///
/// The view ensures that text is legible in both light and dark mode
/// by using a white background with a light accent color in light mode,
/// and a gray background with a light accent color in dark mode.
struct DynamicHighlightBackground: View {
	@Environment(\.colorScheme) private var colorScheme

	var body: some View {
		colorScheme == .light ?
		ZStack {
			Color.white
			Color.defaultAccentColor.opacity(0.075)
		} : ZStack {
			Color.gray.opacity(0.25)
			Color.defaultAccentColor.opacity(0.1)
		}
	}
}
