//
//  AccentColor.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-18.
//

import SwiftUI

enum AccentColorType: Int, Identifiable, CaseIterable {
	var id: Self { self }
	case berry, orange, yellow, green, clover, teal, blue, indigo, purple
}

extension AccentColorType {
	var title: String {
		switch self {
		case .berry: return "accentColor.berry"
		case .orange: return "accentColor.orange"
		case .yellow: return "accentColor.yellow"
		case .green: return "accentColor.green"
		case .clover: return "accentColor.clover"
		case .teal: return "accentColor.teal"
		case .blue: return "accentColor.blue"
		case .indigo: return "accentColor.indigo"
		case .purple: return "accentColor.purple"
		}
	}

	var associatedColor: Color {
		switch self {
		case .berry: return Color(hex: 0xFE04459)
		case .orange: return Color(hex: 0xC65235)
		case .yellow: return Color(hex: 0xC99333)
		case .green: return Color(hex: 0x651AC4D)
		case .clover: return Color(hex: 0x4CA68B)
		case .teal: return Color(hex: 0x46D7E6)
		case .blue: return Color(hex: 0x4293BE)
		case .indigo: return Color(hex: 0x3E569F)
		case .purple: return Color(hex: 0x5B41BB)
		}
	}
}
