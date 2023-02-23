//
//  AccentColorSettings.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-23.
//

import SwiftUI

struct AccentColorSettings: View {
	@Preference(\.accentColor) private var accentColor

	var body: some View {
		Form {
			Picker("settings.general.accentColor", selection: $accentColor) {
				ForEach(AccentColorType.allCases) { (accent) in
					Label {
						Text(LocalizedStringKey(accent.title))
					} icon: {
						SFSymbols.circleFilled
							.foregroundColor(accent.associatedColor)
					}
					.labelStyle(.titleAndIcon)
					.tag(accent.rawValue)
				}
			}
			.labelsHidden()
			.pickerStyle(.inline)
			.navigationTitle("settings.general.appIcon")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

struct AccentColorSettings_Previews: PreviewProvider {
	static var previews: some View {
		AccentColorSettings()
	}
}
