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
	@Preference(\.isShowingAppBadge) private var isShowingAppBadge
	@Preference(\.isShowingTabBadge) private var isShowingTabBadge
	@Preference(\.isLockedInPortrait) private var isLockedInPortrait

	private var homeVM: HomeViewModel = .init()
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
					.transition(.asymmetric(insertion: .opacity.animation(.default), removal: .opacity))
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
						.badge(isShowingTabBadge ? pendingTasksCount : 0)
					SettingsView()
						.tabItem {
							SFSymbols.gear
							Text("Settings")
						}
				}
				.onReceive(homeVM.$isFetchingData) { _ in
					pendingTasksCount = homeVM.pendingTasks.count
					if isShowingAppBadge { setAppBadgeOfPendingTasks() }
				}
				.onAppear {
					isLockedInPortrait ? appDelegate.lockInPortraitMode() : appDelegate.unlockPortraitMode()
				}
				.onChange(of: isLockedInPortrait) { _ in
					isLockedInPortrait ? appDelegate.lockInPortraitMode() : appDelegate.unlockPortraitMode()
				}
				.onChange(of: isShowingAppBadge) { _ in
					setAppBadgeOfPendingTasks()
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
			}
		}
	}
}

extension TaskGuru_SelfApp {
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

	private func setAppBadgeOfPendingTasks() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { success, error in
			if success {
				Task {
					await MainActor.run {
						switch isShowingAppBadge {
						case true:	UIApplication.shared.applicationIconBadgeNumber = homeVM.pendingTasks.count
						case false: UIApplication.shared.applicationIconBadgeNumber = 0
						}
					}
				}
			} else if let error = error {
				print(error.localizedDescription)
			}
		}
	}
}
