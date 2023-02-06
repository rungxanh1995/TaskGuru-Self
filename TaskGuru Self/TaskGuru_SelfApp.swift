//
//  TaskGuru_SelfApp.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

// swiftlint:disable type_name
@main
struct TaskGuru_SelfApp: App {
	var body: some Scene {
		WindowGroup {
			TabView {
				HomeView()
					.tabItem {
						SFSymbols.house
						Text("Home")
					}
				SettingsView()
					.tabItem {
						SFSymbols.gear
						Text("Settings")
					}
			}
			.setUpColorTheme()
		}
	}
}
