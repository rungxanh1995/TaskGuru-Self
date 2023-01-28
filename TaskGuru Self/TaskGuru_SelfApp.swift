//
//  TaskGuru_SelfApp.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

@main
struct TaskGuru_SelfApp: App {
    var body: some Scene {
        WindowGroup {
			TabView {
				HomeView()
					.tabItem {
						Image(systemName: "house")
						Text("Home")
					}
				SettingsView()
					.tabItem {
						Image(systemName: "gearshape")
						Text("Settings")
					}
			}
			.setUpColorTheme()
        }
    }
}
