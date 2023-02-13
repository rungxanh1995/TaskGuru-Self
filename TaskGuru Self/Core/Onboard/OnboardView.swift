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
		VStack(alignment: .center, spacing: 20) {
			icon
				.resizable()
				.scaledToFit()
				.frame(width: 100, height: 100)
				.foregroundColor(.accentColor)

			Text(title)
				.font(.title)
				.bold()

			Text(description)
				.multilineTextAlignment(.center)
				.foregroundColor(.secondary)
		}
		.padding(.horizontal, 40)
	}
}

struct OnboardVie_Previews: PreviewProvider {
	static var previews: some View {
		OnboardView(
			icon: OnboardFeature.features[1].icon,
			title: OnboardFeature.features[1].title,
			description: OnboardFeature.features[1].description)
	}
}
