//
//  Color.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-18.
//

import SwiftUI

extension Color {
	@Preference(\.accentColor) private static var userAccentColor

	/// Returns a color to be used as default for the app, otherwise uses the defined accent color in Assets catalog.
	static var defaultAccentColor: Color {
		guard let accentColor = AccentColorType(rawValue: userAccentColor) else {
			return Color("AccentColor")
		}

		switch accentColor {
		case .berry: return Color(hex: 0xE04459)
		case .orange: return Color(hex: 0xE55B39)
		case .yellow: return Color(hex: 0xE8A53A)
		case .green: return Color(hex: 0x5DC556)
		case .clover: return Color(hex: 0x57BD9F)
		case .blue: return Color(hex: 0x4CA7DA)
		case .indigo: return Color(hex: 0x445FB8)
		case .purple: return Color(hex: 0x6647D7)
		}
	}

	/// The custom pink color specific to TaskGuru
	static var appPink: Color {	Color(hex: 0xE04459) }
	/// The custom orange color specific to TaskGuru
	static var appOrange: Color { Color(hex: 0xE55B39) }
	/// The custom yellow color specific to TaskGuru
	static var appYellow: Color { Color(hex: 0xE8A53A) }
	/// The custom green color specific to TaskGuru
	static var appGreen: Color { Color(hex: 0x5DC556) }
	/// The custom teal color specific to TaskGuru
	static var appTeal: Color { Color(hex: 0x57BD9F) }
	/// The custom blue color specific to TaskGuru
	static var appBlue: Color { Color(hex: 0x4CA7DA) }
	/// The custom indigo color specific to TaskGuru
	static var appIndigo: Color { Color(hex: 0x445FB8) }
	/// The custom indigo color specific to TaskGuru
	static var appPurple: Color { Color(hex: 0x6647D7) }

	/// Allows initializing color from hex code with format "0xABCDEF"
	init(hex: UInt, alpha: Double = 1) {
		self.init(
			.displayP3,
			red: Double((hex >> 16) & 0xff) / 255,
			green: Double((hex >> 08) & 0xff) / 255,
			blue: Double((hex >> 00) & 0xff) / 255,
			opacity: alpha
		)
	}
}
