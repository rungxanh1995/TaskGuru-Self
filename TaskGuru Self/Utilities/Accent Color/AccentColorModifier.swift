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
		case .berry: return Color(hex: 0xE14359)
		case .orange: return Color(hex: 0xE55A38)
		case .yellow: return Color(hex: 0xE7A63A)
		case .green: return Color(hex: 0x5CC557)
		case .clover: return Color(hex: 0x56BDA0)
		case .teal: return Color(hex: systemScheme == .light ? 0x00BBCC : 0x46D7E6)
		case .blue: return Color(hex: 0x4CA7DA)
		case .indigo: return Color(hex: 0x435FB7)
		case .purple: return Color(hex: 0x6747D9)
		}
	}

	func body(content: Content) -> some View {
		content
			.tint(selectedAccentColor)
	}
}
