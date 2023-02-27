//
//  AccentColorModifier.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-18.
//

import SwiftUI

struct AccentColorModifier: ViewModifier {
	@Environment(\.colorScheme) private var systemScheme

	@AppStorage(UserDefaultsKey.accentColor)
	private var accentColor: Int = AccentColorType.clover.rawValue

	private var selectedAccentColor: Color? {
		guard let accentColor = AccentColorType(rawValue: self.accentColor) else { return nil }
		switch accentColor {
		case .berry: return Color(hex: 0xE14459)
		case .orange: return Color(hex: 0xE65C39)
		case .yellow: return Color(hex: 0xE8A53A)
		case .green: return Color(hex: 0x5DC555)
		case .clover: return Color(hex: 0x56BD9F)
		case .blue: return Color(hex: 0x4CA7DB)
		case .indigo: return Color(hex: 0x445FB9)
		case .purple: return Color(hex: 0x6647D8)
		}
	}

	func body(content: Content) -> some View {
		content
			.tint(selectedAccentColor)
	}
}
