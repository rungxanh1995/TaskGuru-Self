//
//  ContextPreviewType.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-19.
//

import Foundation

enum ContextPreviewType: Int, Identifiable, CaseIterable {
	var id: Self { self }
	case cell
	case detail
}

extension ContextPreviewType {
	var title: String {
		switch self {
		case .cell: return "Cell"
		case .detail: return "Detail"
		}
	}
}
