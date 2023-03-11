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
		case .berry: return Color(hex: systemScheme == .light ? 0xE51817 : 0xE54545)
		case .orange: return Color(hex: systemScheme == .light ? 0xE47101 : 0xE4892E)
		case .yellow: return Color(hex: systemScheme == .light ? 0xF0B302 : 0xE5BC45)
		case .green: return Color(hex: systemScheme == .light ? 0x70BE00 : 0xA3E547)
		case .clover: return Color(hex: systemScheme == .light ? 0x02C564 : 0x46E495)
		case .teal: return Color(hex: systemScheme == .light ? 0x00BBCC : 0x44D7E6)
		case .blue: return Color(hex: systemScheme == .light ? 0x0080FE : 0x4CA5FF)
		case .indigo: return Color(hex: systemScheme == .light ? 0x5500FE : 0x9966FF)
		case .purple: return Color(hex: systemScheme == .light ? 0xA901FF : 0xC34CFE)
		}
	}

	func body(content: Content) -> some View {
		content
			.tint(selectedAccentColor)
	}
}
