//
//  BoldFontModifier.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 15/3/23.
//

import SwiftUI

struct BoldFontModifier: ViewModifier {
	@AppStorage(UserDefaultsKey.isBoldFont) private var boldFont: Bool = false

	func body(content: Content) -> some View {
		// Semibold is bold enough, and looks more inline with systemwide "Bold Text" thickness
		content
			.fontWeight(boldFont ? .semibold : nil)
	}
}
