//
//  HomeQuickAction.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-17.
//

import UIKit

enum HomeQuickAction {
	enum UserInfoType: String {
		case addTask, allTasks
	}

	static var selectedAction: UIApplicationShortcutItem?

	static var addTaskUserInfo: [String: NSSecureCoding] {
		["name": UserInfoType.addTask.rawValue as NSSecureCoding]
	}

	static var allTasksUserInfo: [String: NSSecureCoding] {
		["name": UserInfoType.allTasks.rawValue as NSSecureCoding]
	}

	static var allShortcutItems: [UIApplicationShortcutItem] = [
		.init(type: UserInfoType.addTask.rawValue, localizedTitle: NSLocalizedString("label.task.add", comment: ""),
					localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .add), userInfo: addTaskUserInfo)
	]
}
