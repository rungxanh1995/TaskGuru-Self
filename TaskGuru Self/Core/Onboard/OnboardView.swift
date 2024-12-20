//
//  OnboardView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-13.
//

import SwiftUI

struct OnboardView: View {
	let icon: Image
	let title: LocalizedStringKey
	let description: LocalizedStringKey

	var body: some View {
		HStack(spacing: 16) {
			icon
				.resizable()
				.scaledToFit()
				.frame(width: 40, height: 40)
				.foregroundColor(.defaultAccentColor)

			VStack(alignment: .leading) {
				Text(title)
					.font(.headline)
					.bold()
					.multilineTextAlignment(.leading)

				Text(description)
					.multilineTextAlignment(.leading)
					.foregroundColor(.secondary)
			}
		}
		.padding(.horizontal, 12)
	}
}

struct OnboardView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardView(
			icon: OnboardFeature.features[1].icon,
			title: OnboardFeature.features[1].title,
			description: OnboardFeature.features[1].description)
	}
}
