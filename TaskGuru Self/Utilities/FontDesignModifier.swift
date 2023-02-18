//
//  FontDesignModifier.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-18.
//

import SwiftUI

struct FontDesignModifier: ViewModifier {
	@AppStorage(UserDefaultsKey.isRoundedFontEnabled)
	private var roundedFont: Bool = false

	func body(content: Content) -> some View {
		content
			.fontDesign(roundedFont ? .rounded : .default)
	}
}
