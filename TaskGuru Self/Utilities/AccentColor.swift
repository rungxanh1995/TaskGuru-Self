//
//  AccentColor.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-18.
//

import Foundation

enum AccentColorType: Int, Identifiable, CaseIterable {
	var id: Self { self }
	case blue, teal, indigo, pink, red, orange, yellow, green, mint
}

extension AccentColorType {
	var title: String {
		switch self {
		case .blue: return "Blue"
		case .teal: return "Teal"
		case .indigo: return "Indigo"
		case .pink: return "Pink"
		case .red: return "Red"
		case .orange: return "Orange"
		case .yellow: return "Yellow"
		case .green: return "Green"
		case .mint: return "Mint"
		}
	}
}
