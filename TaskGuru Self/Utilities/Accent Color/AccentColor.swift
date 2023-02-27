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
}
