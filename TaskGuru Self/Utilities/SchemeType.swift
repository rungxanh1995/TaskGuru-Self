//
//  SchemeType.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

enum SchemeType: Int, Identifiable, CaseIterable {
	var id: Self { self }
	case system
	case light
	case dark
}

extension SchemeType {
	var title: String {
		switch self {
		case .system: return "System"
		case .light: return "Light"
		case .dark: return "Dark"
		}
	}
}
