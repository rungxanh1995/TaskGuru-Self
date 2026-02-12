//
//  AppIcon.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-21.
//

import SwiftUI

enum AppIconType: Int, Identifiable, CaseIterable {
	var id: Self { self }
	case dew, spring, summer, fall, winter, sky, midnight, iris, berry
}

extension AppIconType {
	/// Used as reference to localizable string key
	var title: String {
		switch self {
		case .dew: return "appIcon.dew"
		case .spring: return "appIcon.spring"
		case .summer: return "appIcon.summer"
		case .fall: return "appIcon.fall"
		case .winter: return "appIcon.winter"
		case .sky: return "appIcon.sky"
		case .midnight: return "appIcon.midnight"
		case .iris: return "appIcon.iris"
		case .berry: return "appIcon.berry"
		}
	}

	/// Used as direct reference to icon image name in Assets catalog
	var assetName: String {
		switch self {
		case .dew: return "AppIconDew"
		case .spring: return "AppIconSpring"
		case .summer: return "AppIconSummer"
		case .fall: return "AppIconFall"
		case .winter: return "AppIconWinter"
		case .sky: return "AppIconSky"
		case .midnight: return "AppIconMidnight"
		case .iris: return "AppIconIris"
		case .berry: return "AppIconBerry"
		}
	}

	/// Used to display as accompanying icon image
	var iconImage: Image {
		switch self {
		case .dew:
            return Image(.appIconDew)
		case .spring:
			return Image(.appIconSpring)
		case .summer:
			return Image(.appIconSummer)
		case .fall:
			return Image(.appIconFall)
		case .winter:
			return Image(.appIconWinter)
		case .sky:
			return Image(.appIconSky)
		case .midnight:
			return Image(.appIconMidnight)
		case .iris:
			return Image(.appIconIris)
		case .berry:
			return Image(.appIconBerry)
		}
	}
}
