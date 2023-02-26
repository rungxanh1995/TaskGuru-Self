//
//  Image.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-21.
//

import SwiftUI

extension Image {
	/// Frames image as a medium icon size for a row in App icon settings view.
	func asIconSize() -> some View {
		self
			.resizable()
			.scaledToFit()
			.frame(width: 40, height: 40)
			.clipShape(RoundedRectangle(cornerRadius: 9))
	}

	/// Frames image as a small icon size for a row in Settings view.
	func asSettingsIconSize() -> some View {
		self
			.resizable()
			.scaledToFit()
			.frame(width: 28, height: 28)
			.clipShape(RoundedRectangle(cornerRadius: 9*(28/40)))
	}
}
