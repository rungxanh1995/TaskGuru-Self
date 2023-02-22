//
//  Image.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-21.
//

import SwiftUI

extension Image {
	func asFootnoteIcon() -> some View {
		self
			.resizable()
			.scaledToFit()
			.frame(width: 44, height: 44)
			.clipShape(RoundedRectangle(cornerRadius: 10))
	}
}
