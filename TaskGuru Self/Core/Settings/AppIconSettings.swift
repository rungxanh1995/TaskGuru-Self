//
//  AppIconSettings.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-23.
//

import SwiftUI

struct AppIconSettings: View {
	@Preference(\.activeAppIcon) private var activeAppIcon

	var body: some View {
		VStack {
			Form {
				Picker("settings.general.appIcon", selection: $activeAppIcon) {
					ForEach(AppIconType.allCases) { (appIcon) in
						Label {
							Text(LocalizedStringKey(appIcon.title))
						} icon: {
							appIcon.iconImage.asSettingsIconSize()
						}
						.tag(appIcon.rawValue)
					}
				}
				.labelsHidden()
				.pickerStyle(.inline)
			}
			.navigationTitle("settings.general.appIcon")
			.navigationBarTitleDisplayMode(.inline)
			.onChange(of: activeAppIcon) { iconValue in
				updateAppIcon(from: iconValue)
			}
		}
	}

	private func updateAppIcon(from iconValue: Int) {
		let iconName = AppIconType(rawValue: iconValue)?.assetName
		UIApplication.shared.setAlternateIconName(iconName)
		haptic(.notification(.success))
	}
}

struct AppIconSettings_Previews: PreviewProvider {
	static var previews: some View {
		AppIconSettings()
	}
}
