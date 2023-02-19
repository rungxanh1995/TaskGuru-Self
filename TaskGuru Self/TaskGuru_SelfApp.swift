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
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@Environment(\.scenePhase) private var scenePhase

	@AppStorage(UserDefaultsKey.isOnboarding) private var isOnboarding: Bool = true
	@Preference(\.accentColor) private var accentColor
	@Preference(\.badgeType) private var badgeType
	@Preference(\.isShowingAppBadge) private var isShowingAppBadge
	@Preference(\.isShowingTabBadge) private var isShowingTabBadge
	@Preference(\.isLockedInPortrait) private var isLockedInPortrait
	@Preference(\.isTabNamesEnabled) private var isTabNamesEnabled

	private var homeVM: HomeViewModel = .init()
	@State private var pendingTasksCount: Int = 0

	init() {
		setAlertColor()
		if isLockedInPortrait { appDelegate.lockInPortraitMode() } else { appDelegate.unlockPortraitMode() }
	}

	var body: some Scene {
		WindowGroup {
			if isOnboarding {
				OnboardContainerView()
					.transition(.asymmetric(insertion: .opacity.animation(.default), removal: .opacity))
					.setUpColorTheme()
					.setUpFontDesign()
					.setUpAccentColor()
			} else {
				TabView {
					HomeView()
						.tabItem {
							SFSymbols.house
							if isTabNamesEnabled { Text("Home") }
						}
					PendingView()
						.tabItem {
							SFSymbols.clock
							if isTabNamesEnabled { Text("Pending") }
						}
						.badge(isShowingTabBadge ? pendingTasksCount : 0)
					SettingsView()
						.tabItem {
							SFSymbols.gear
							if isTabNamesEnabled { Text("Settings") }
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
				.onChange(of: scenePhase) { newPhase in
					switch newPhase {
					case .background:
						addHomeScreenQuickActions()
						HomeQuickAction.selectedAction = nil
					case .active:
						handleQuickActionSelected()
					default:
						break
					}
				}
				.environmentObject(homeVM)
				.transition(.asymmetric(insertion: .opacity.animation(.default), removal: .opacity))
				.setUpColorTheme()
				.setUpFontDesign()
				.setUpAccentColor()
			}
		}
	}
}

extension TaskGuru_SelfApp {
	private func setAlertColor() {
		UIView.appearance(for: UITraitCollection(userInterfaceStyle: .light),
											whenContainedInInstancesOf: [UIAlertController.self])
			.tintColor = UIColor(Color.defaultAccentColor)

		UIView.appearance(for: UITraitCollection(userInterfaceStyle: .dark),
											whenContainedInInstancesOf: [UIAlertController.self])
			.tintColor = UIColor(Color.defaultAccentColor)
	}

	private func addHomeScreenQuickActions() {
		UIApplication.shared.shortcutItems = HomeQuickAction.allShortcutItems
	}

	private func handleQuickActionSelected() {
		guard let selectedAction = HomeQuickAction.selectedAction,
					let userInfo = selectedAction.userInfo,
					let actionName = userInfo["name"] as? String else { return }

		defer {
			// This is a bugfix to "add task" popping up when app is not in foreground,
			// i.e. when user enters system multitasking screen, then comes back to app.
			var newUserInfo = userInfo
			newUserInfo["name"] = HomeQuickAction.UserInfoType.allTasks.rawValue as any NSSecureCoding
			let updatedAction = UIApplicationShortcutItem(
				type: selectedAction.type, localizedTitle: selectedAction.localizedTitle, localizedSubtitle: nil,
				icon: selectedAction.icon, userInfo: newUserInfo)
			HomeQuickAction.selectedAction = updatedAction
		}

		switch actionName {
		case HomeQuickAction.UserInfoType.addTask.rawValue:
			homeVM.isShowingAddTaskView = true
		default:
			homeVM.isShowingAddTaskView = false
		}
	}
}

import UserNotifications

extension TaskGuru_SelfApp {

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
		case .upcoming: return homeVM.allTasks.filter { $0.dueDate.isInTheFuture && $0.isNotDone }.count
		}
	}
}
