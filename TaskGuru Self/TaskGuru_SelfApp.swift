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

	private var homeVM: HomeViewModel = .init()
	private var appState: AppState = .init()

	init() {
		UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
			.tintColor = UIColor(Color("AccentColor"))
	}

	var body: some Scene {
		WindowGroup {
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
				SettingsView()
					.tabItem {
						SFSymbols.gear
						Text("Settings")
					}
			}
			.environmentObject(homeVM)
			.environmentObject(appState)
			.setUpColorTheme()
		}
	}
}
