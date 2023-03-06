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
		case .berry: return Color(hex: 0xE14359)
		case .orange: return Color(hex: 0xE55A38)
		case .yellow: return Color(hex: 0xE7A63A)
		case .green: return Color(hex: 0x5CC557)
		case .clover: return Color(hex: 0x56BDA0)
		case .teal: return Color(hex: 0x00BBCC)
		case .blue: return Color(hex: 0x4CA7DA)
		case .indigo: return Color(hex: 0x435FB7)
		case .purple: return Color(hex: 0x6747D9)
		}
	}
}
