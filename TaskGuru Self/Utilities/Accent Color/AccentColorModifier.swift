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
	private var accentColor: Int = AccentColorType.allCases.last!.rawValue

	private var selectedAccentColor: Color? {
		guard let accentColor = AccentColorType(rawValue: self.accentColor) else { return nil }
		switch accentColor {
		case .blue: return .blue
		case .teal: return .teal
		case .indigo: return .indigo
		case .purple: return Color(hex: systemScheme == .light ? 0xD32DF6 : 0xF454FF)
		case .pink: return .pink
		case .berry: return Color(hex: systemScheme == .light ? 0xEF0808 : 0xFF6060)
		case .red: return .red
		case .orange: return .orange
		case .yellow: return .yellow
		case .green: return .green
		case .mint: return .mint
		case .clover: return Color(hex: systemScheme == .light ? 0x2AA18A : 0x2CA18A)
		}
	}

	func body(content: Content) -> some View {
		content
			.tint(selectedAccentColor)
	}
}
