//
//  OnboardContainerView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-13.
//

import SwiftUI

struct OnboardContainerView: View {
	@AppStorage(UserDefaultsKey.isOnboarding) private var isOnboarding: Bool?

	var body: some View {
		VStack {
			TabView {
				ForEach(OnboardFeature.features) { feature in
					OnboardView(
						icon: feature.icon,
						title: feature.title,
						description: feature.description)
				}

			}
			.tabViewStyle(.page(indexDisplayMode: .always))
			.indexViewStyle(.page(backgroundDisplayMode: .always))

			Spacer()

			Button("Get Started") {
				withAnimation {	isOnboarding = false }
			}
			.buttonStyle(.borderedProminent)
		}
	}
}

struct OnboardContentView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardContainerView()
	}
}
