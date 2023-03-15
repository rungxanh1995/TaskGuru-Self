//
//  FontWidthModifier.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 14/3/23.
//

import SwiftUI

struct FontWidthModifier: ViewModifier {
	@AppStorage(UserDefaultsKey.fontWidth) private var fontWidth: Int = FontWidthType.standard.rawValue

	private var selectedFontWidth: Font.Width? {
		guard let fontWidth = FontWidthType(rawValue: self.fontWidth) else { return nil }
		switch fontWidth {
		case .standard: return .standard
		case .condensed: return .condensed
		case .compressed: return .compressed
		case .expanded: return .expanded
		}
	}

	func body(content: Content) -> some View {
		content
			.fontWidth(selectedFontWidth)
	}
}
