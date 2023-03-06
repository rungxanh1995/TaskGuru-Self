//
//  NavigationTitle.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-17.
//

import SwiftUI

/// Intended as a replacement of a `NavigationStack` or `NavigationView` title.
///
/// Sample usage:
/// ```
/// NavigationView {
///	  List {
///      // Your view here
///   }
///   .toolbar {
///	    ToolbarItem(placement: .principal) {
///	      NavigationTitle(text: "Custom Navigation Title")
///	    }
///	  }
/// }
/// ```
struct NavigationTitle: View {
	@Preference(\.accentColor) private var accentColor

	let text: LocalizedStringKey

	var body: some View {
		let accent = AccentColorType(rawValue: accentColor)?.associatedColor ?? .defaultAccentColor
		Text(text)
			.foregroundColor(accent)
			.font(.headline)
			.bold()
	}
}

struct GradientNavigationTitle_Previews: PreviewProvider {
	static var previews: some View {
		NavigationTitle(text: "All Tasks")
	}
}
