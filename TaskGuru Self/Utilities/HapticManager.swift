//
//  HapticManager.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import UIKit

fileprivate final class HapticManager {
	static let shared: HapticManager = .init()
	private let feedback: UINotificationFeedbackGenerator = .init()
	
	private init() { }
	
	func trigger(_ notifType: UINotificationFeedbackGenerator.FeedbackType) {
		feedback.notificationOccurred(notifType)
	}
}

func haptic(_ notifType: UINotificationFeedbackGenerator.FeedbackType) {
	if UserDefaults.standard.bool(forKey: UserDefaultsKey.hapticsEnabled) {
		HapticManager.shared.trigger(notifType)
	}
}
