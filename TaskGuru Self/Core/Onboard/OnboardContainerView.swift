//
//  OnboardContainerView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-13.
//

import SwiftUI

struct OnboardContainerView: View {
	@AppStorage(UserDefaultsKey.isOnboarding)
	private var isOnboarding: Bool?
	@Preference(\.activeAppIcon) private var activeAppIcon

	@Environment(\.dismiss) private var dismissThisView

	var body: some View {
		VStack {
			ScrollView(showsIndicators: false) {
				VStack(alignment: .center, spacing: 24) {
					// app icon
					if let icon = AppIconType(rawValue: activeAppIcon)?.iconImage {
						icon.asLargeIconSize()
					} else {
						Image("app-logo").asLargeIconSize()
					}
					// welcome to
					Text("Welcome to TaskGuru")
						.font(.largeTitle)
						.fontWeight(.bold)
						.multilineTextAlignment(.center)
				}
				.padding(.horizontal, 40)
				.padding(.top, 40)
				.padding(.bottom, 32)

				VStack(alignment: .leading, spacing: 32) {
					ForEach(OnboardFeature.features) { feature in
						OnboardView(
							icon: feature.icon,
							title: feature.title,
							description: feature.description)
					}
				}
				.padding(.bottom)
			}

			switch isOnboarding {
			case .none: allSet
			case .some: EmptyView()
			}
		}
		.padding(.horizontal, 20)
	}
}

extension OnboardContainerView {
	/// Button to display when user is new to the app
	private var allSet: some View {
		Button {
			withAnimation {	isOnboarding = false }
			haptic(.buttonPress)
		} label: {
			Text("onboarding.buttons.onboarding.dismiss")
				.padding(.vertical, 8)
				.frame(maxWidth: .infinity)
		}
		.bold()
		.buttonStyle(.borderedProminent)
		.buttonBorderShape(.roundedRectangle(radius: 16))
		.tint(.defaultAccentColor)
		.padding(.bottom, 20)
	}
}

struct OnboardContainerView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardContainerView()
	}
}
