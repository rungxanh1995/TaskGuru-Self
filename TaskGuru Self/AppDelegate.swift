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
		UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
		AppDelegate.orientationLock = .portrait
	}

	func unlockPortraitMode() {
		AppDelegate.orientationLock = .all
	}
}
