//
//  AppDelegate.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-14.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

	static var orientationLock = UIInterfaceOrientationMask.all

	func application(
		_ application: UIApplication,
		supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return AppDelegate.orientationLock
	}

	func lockInPortraitMode() {
		if #available(iOS 16.0, *) {
			let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
			windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))

			UIApplication.navigationTopViewController()?.setNeedsUpdateOfSupportedInterfaceOrientations()
		} else {
			UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
		}

		AppDelegate.orientationLock = .portrait
	}

	func unlockPortraitMode() {
		AppDelegate.orientationLock = .all
	}

	func application(
		_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions) -> UISceneConfiguration {
			if let selectedAction = options.shortcutItem {
				HomeQuickAction.selectedAction = selectedAction
			}

			let sceneConfig = UISceneConfiguration(name: "Quick Action Scene", sessionRole: connectingSceneSession.role)
			sceneConfig.delegateClass = QuickActionSceneDelegate.self
			return sceneConfig
	}
}

private class QuickActionSceneDelegate: UIResponder, UIWindowSceneDelegate {
	func windowScene(
		_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem,
		completionHandler: @escaping (Bool) -> Void) {
			HomeQuickAction.selectedAction = shortcutItem
	}
}
