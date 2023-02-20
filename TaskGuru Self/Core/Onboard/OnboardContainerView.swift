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

	@Environment(\.dismiss) private var dismissThisView

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

			switch isOnboarding {
			case .none: allSet
			case .some: dismiss
			}
		}
	}
}

extension OnboardContainerView {
	/// Button to display when user is new to the app
	private var allSet: some View {
		Button("onboarding.buttons.onboarding.dismiss") {
			withAnimation {	isOnboarding = false }
			haptic(.success)
		}
		.bold()
		.buttonStyle(.bordered)
		.buttonBorderShape(.capsule)
		.tint(.defaultAccentColor)
	}

	/// Button to display when user might be seeing this view in Settings
	private var dismiss: some View {
		Button {
			dismissThisView()
			haptic(.success)
		} label: {
			Label {
				Text("onboarding.buttons.onboarded.dismiss")
			} icon: {
				SFSymbols.xmark
			}
			.labelStyle(.titleOnly)
		}
		.bold()
		.buttonStyle(.bordered)
		.buttonBorderShape(.capsule)
		.tint(.gray)
	}
}

struct OnboardContainerView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardContainerView()
	}
}
