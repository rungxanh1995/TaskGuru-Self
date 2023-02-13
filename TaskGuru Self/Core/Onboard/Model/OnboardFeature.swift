//
//  OnboardFeature.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-13.
//

import SwiftUI

struct OnboardFeature: Identifiable {
	var id: UUID = .init()
	let icon: Image
	let title: LocalizedStringKey
	let description: LocalizedStringKey
}

extension OnboardFeature {
	static let features: [OnboardFeature] = [
		OnboardFeature(
			icon: SFSymbols.house,
			title: "Home tab",
			description: "All your tasks in sections, so you can easily track which ones are overdue, due today, or upcoming"),
		OnboardFeature(
			icon: SFSymbols.clockBadge,
			title: "Pending Tasks tab",
			description: "Find tasks not completed here"),
		OnboardFeature(
			icon: SFSymbols.listFilled,
			title: "Quick Actions",
			description: "Tap and hold each task from the list to use quick actions")
	]
}
