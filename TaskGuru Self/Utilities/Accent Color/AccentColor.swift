//
//  AccentColor.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-18.
//

import SwiftUI

enum AccentColorType: Int, Identifiable, CaseIterable {
	var id: Self { self }
	case blue, teal, indigo, pink, berry, red, orange, yellow, green, mint, clover
}

extension AccentColorType {
	var title: String {
		switch self {
		case .blue: return "accentColor.blue"
		case .teal: return "accentColor.teal"
		case .indigo: return "accentColor.indigo"
		case .pink: return "accentColor.pink"
		case .berry: return "accentColor.berry"
		case .red: return "accentColor.red"
		case .orange: return "accentColor.orange"
		case .yellow: return "accentColor.yellow"
		case .green: return "accentColor.green"
		case .mint: return "accentColor.mint"
		case .clover: return "accentColor.clover"
		}
	}

	var associatedColor: Color {
		switch self {
		case .blue: return .blue
		case .teal: return .teal
		case .indigo: return .indigo
		case .pink: return .pink
		case .berry: return Color(hex: 0xEF0808)
		case .red: return .red
		case .orange: return .orange
		case .yellow: return .yellow
		case .green: return .green
		case .mint: return .mint
		case .clover: return Color(hex: 0x4597A1)
		}
	}
}
