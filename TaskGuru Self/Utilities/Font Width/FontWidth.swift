//
//  FontWidth.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 14/3/23.
//

import Foundation

enum FontWidthType: Int, Identifiable, CaseIterable {
	var id: Self { self }
	case standard
	case condensed
	case compressed
	case expanded
}

extension FontWidthType {
	var title: String {
		switch self {
		case .standard: return "fontWidth.standard"
		case .condensed: return "fontWidth.condensed"
		case .compressed: return "fontWidth.compressed"
		case .expanded: return "fontWidth.expanded"
		}
	}
}
