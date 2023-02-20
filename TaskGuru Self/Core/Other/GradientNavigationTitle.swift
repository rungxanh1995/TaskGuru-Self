//
//  GradientNavigationTitle.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-17.
//

import SwiftUI

struct GradientNavigationTitle: View {
	@Preference(\.accentColor) private var accentColor

	let text: LocalizedStringKey

	var body: some View {
		Text(text)
			.font(.system(.title, design: .rounded))
			.fontWeight(.bold)
			.foregroundStyle(Color.defaultAccentColor.gradient)
	}
}

struct GradientNavigationTitle_Previews: PreviewProvider {
	static var previews: some View {
		GradientNavigationTitle(text: "All Tasks")
	}
}
