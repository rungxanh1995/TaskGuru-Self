//
//  FontDesign.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-18.
//

import Foundation

enum FontDesignType: Int, Identifiable, CaseIterable {
	var id: Self { self }
	case system
	case rounded
	case monospaced
	case serif
}

extension FontDesignType {
	var title: String {
		switch self {
		case .system: return "fontDesign.system"
		case .rounded: return "fontDesign.rounded"
		case .monospaced: return "fontDesign.monospaced"
		case .serif: return "fontDesign.serif"
		}
	}
}
