//
//  TaskGuru_SelfApp.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import UIKit
import SwiftUI

// swiftlint:disable type_name
@main
struct TaskGuru_SelfApp: App {
	@AppStorage(UserDefaultsKey.isOnboarding) private var isOnboarding: Bool = true
	@AppStorage(UserDefaultsKey.isShowingTabBadge) private var isShowingTabBadge: Bool?

	private var homeVM: HomeViewModel = .init()
	private var appState: AppState = .init()
	@State private var pendingTasksCount: Int = 0

	init() {
		UIView.appearance(for: UITraitCollection(userInterfaceStyle: .light),
											whenContainedInInstancesOf: [UIAlertController.self])
		.tintColor = UIColor(Color("AccentColor"))

		UIView.appearance(for: UITraitCollection(userInterfaceStyle: .dark),
											whenContainedInInstancesOf: [UIAlertController.self])
		.tintColor = UIColor(Color("AccentColor"))
	}

	var body: some Scene {
		WindowGroup {
			if isOnboarding {
				OnboardContainerView()
					.setUpColorTheme()
			} else {
				TabView {
					HomeView()
						.tabItem {
							SFSymbols.house
							Text("Home")
						}
					PendingView()
						.tabItem {
							SFSymbols.clock
							Text("Pending")
						}
						.badge((isShowingTabBadge ?? true) ? pendingTasksCount : 0)
					SettingsView()
						.tabItem {
							SFSymbols.gear
							Text("Settings")
						}
				}
				.onReceive(homeVM.$isFetchingData) { _ in
					pendingTasksCount = homeVM.pendingTasks.count
				}
				.environmentObject(homeVM)
				.environmentObject(appState)
				.setUpColorTheme()
			}
		}
	}
}
