//
//  RootView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-20.
//

import SwiftUI

enum Tab: Int, Hashable { case home, pending, settings }

struct RootView: View {
	@Preference(\.isShowingTabBadge) private var isShowingTabBadge
	@Preference(\.isTabNamesEnabled) private var isTabNamesEnabled

	@EnvironmentObject private var homeVM: HomeViewModel
	@SceneStorage("selected-tab") private var selectedTab: Tab = .home
	@State var pendingTasksCount: Int = 0

	var body: some View {
		TabView(selection: .init(get: {
			selectedTab
		}, set: { newTab in
			haptic(.tabSelection)
			selectedTab = newTab
		})) {
			HomeView()
				.tag(Tab.home)
				.tabItem {
					SFSymbols.house
					if isTabNamesEnabled { Text("home.tab.title") }
				}
			PendingView()
				.tag(Tab.pending)
				.tabItem {
					SFSymbols.clock
					if isTabNamesEnabled { Text("pending.tab.title") }
				}
				.badge(isShowingTabBadge ? pendingTasksCount : 0)
			SettingsView()
				.tag(Tab.settings)
				.tabItem {
					SFSymbols.gear
					if isTabNamesEnabled { Text("settings.tab.title") }
				}
		}
		.environmentObject(homeVM)
		.onReceive(homeVM.$isFetchingData) { _ in
			pendingTasksCount = homeVM.pendingTasks.count
		}
	}
}

struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootView().environmentObject(HomeViewModel())
	}
}
