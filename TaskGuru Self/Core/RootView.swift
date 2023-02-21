//
//  RootView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-20.
//

import SwiftUI

enum Tab: Int, Hashable { case home, pending, settings }

struct RootView: View {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	@Preference(\.accentColor) private var accentColor
	@Preference(\.badgeType) private var badgeType
	@Preference(\.isShowingAppBadge) private var isShowingAppBadge
	@Preference(\.isShowingTabBadge) private var isShowingTabBadge
	@Preference(\.isLockedInPortrait) private var isLockedInPortrait
	@Preference(\.isTabNamesEnabled) private var isTabNamesEnabled

	private var homeVM: HomeViewModel = .init()
	@SceneStorage("selectedTab") private var selectedTab: Tab = .home
	@State private var pendingTasksCount: Int = 0

	init() {
		setAlertColor()
		if isLockedInPortrait {
			appDelegate.lockInPortraitMode()
		} else {
			appDelegate.unlockPortraitMode()
		}
	}

	var body: some View {
		TabView(selection: $selectedTab) {
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
		.onReceive(homeVM.$isFetchingData) { _ in
			pendingTasksCount = homeVM.pendingTasks.count
			if isShowingAppBadge { setUpAppIconBadge() }
		}
		.onChange(of: accentColor) { _ in
			setAlertColor()
		}
		.onChange(of: badgeType) { _ in
			setUpAppIconBadge()
		}
		.onChange(of: isLockedInPortrait) { _ in
			isLockedInPortrait ? appDelegate.lockInPortraitMode() : appDelegate.unlockPortraitMode()
		}
		.onChange(of: isShowingAppBadge) { _ in
			setUpAppIconBadge()
		}
		.environmentObject(homeVM)
	}
}

extension RootView {
	private func setAlertColor() {
		UIView.appearance(for: UITraitCollection(userInterfaceStyle: .light),
											whenContainedInInstancesOf: [UIAlertController.self])
		.tintColor = UIColor(Color.defaultAccentColor)

		UIView.appearance(for: UITraitCollection(userInterfaceStyle: .dark),
											whenContainedInInstancesOf: [UIAlertController.self])
		.tintColor = UIColor(Color.defaultAccentColor)
	}
}

import UserNotifications

extension RootView {
	private func setUpAppIconBadge() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { success, error in
			if success {
				Task {
					await MainActor.run {
						switch isShowingAppBadge {
						case true:	UIApplication.shared.applicationIconBadgeNumber = badgeNumberForAppIcon()
						case false: UIApplication.shared.applicationIconBadgeNumber = 0
						}
					}
				}
			} else if let error = error {
				print(error.localizedDescription)
			}
		}
	}

	private func badgeNumberForAppIcon() -> Int {
		guard let badge = BadgeType(rawValue: badgeType) else { return 0 }
		switch badge {
		case .allPending: return homeVM.pendingTasks.count
		case .overdue: return homeVM.allTasks.filter { $0.dueDate.isPastToday && $0.isNotDone }.count
		case .dueToday: return homeVM.allTasks.filter { $0.dueDate.isWithinToday && $0.isNotDone }.count
		case .upcoming: return homeVM.allTasks.filter { $0.dueDate.isFromTomorrow && $0.isNotDone }.count
		}
	}
}

struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootView().environmentObject(HomeViewModel())
	}
}
