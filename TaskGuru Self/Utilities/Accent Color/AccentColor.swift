//
//  AccentColor.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-18.
//

import SwiftUI

enum AccentColorType: Int, Identifiable, CaseIterable {
	var id: Self { self }
	case berry, orange, yellow, green, clover, blue, indigo, purple
}

extension AccentColorType {
	var title: String {
		switch self {
		case .berry: return "accentColor.berry"
		case .orange: return "accentColor.orange"
		case .yellow: return "accentColor.yellow"
		case .green: return "accentColor.green"
		case .clover: return "accentColor.clover"
		case .blue: return "accentColor.blue"
		case .indigo: return "accentColor.indigo"
		case .purple: return "accentColor.purple"
		}
	}

	var associatedColor: Color {
		switch self {
		case .berry: return Color(hex: 0xE25A70)
		case .orange: return Color(hex: 0xE86F51)
		case .yellow: return Color(hex: 0xE9B34A)
		case .green: return Color(hex: 0x69CD6D)
		case .clover: return Color(hex: 0x58BEA0)
		case .blue: return Color(hex: 0x5AB4DF)
		case .indigo: return Color(hex: 0x5D78C0)
		case .purple: return Color(hex: 0x7C62DE)
		}
	}
}
