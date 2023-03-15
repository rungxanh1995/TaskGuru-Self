//
//  AppearanceScreen.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 14/3/23.
//

import SwiftUI

struct AppearanceScreen: View {
	@Preference(\.activeAppIcon) private var activeAppIcon
	@Preference(\.accentColor) private var accentColor
	@Preference(\.systemTheme) private var systemTheme
	@Preference(\.fontDesign) private var fontDesign
	@Preference(\.fontWidth) private var fontWidth

	var body: some View {
		Form {
			Section {
				appIcon
				appAccentColor
				colorTheme
			}

			Section {
				fontDesignStyle
				fontWidthStyle
					.disabled(FontDesignType(rawValue: fontDesign) != .system)
			} footer: {
				Text("settings.appearance.footer")
			}
		}
		.navigationTitle("settings.general.appearance")
		.navigationBarTitleDisplayMode(.inline)
	}
}

extension AppearanceScreen {
	private var appIcon: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.app, accent: .appGreen)
		} content: {
			NavigationLink {
				AppIconSettings()
			} label: {
				HStack {
					Text("settings.general.appIcon")
					Spacer()
					if let icon = AppIconType(rawValue: activeAppIcon)?.iconImage {
						icon.asSettingsIconSize()
					} else {
						Image("app-logo").asSettingsIconSize()
					}
				}
			}
		}
	}

	@ViewBuilder private var appAccentColor: some View {
		let currentAccentColor = AccentColorType(rawValue: accentColor)
		settingsRow {
			SettingsIcon(icon: SFSymbols.paintbrush, accent: .defaultAccentColor)
		} content: {
			NavigationLink {
				AccentColorSettings()
			} label: {
				Text("settings.general.accentColor")
					.ifLet(currentAccentColor?.title) { text, colorName in
						text.badge(LocalizedStringKey(colorName))
					}
			}
		}
	}

	private var colorTheme: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.appearance, accent: .appBlue)
		} content: {
			Picker("settings.general.colorTheme", selection: $systemTheme) {
				ForEach(SchemeType.allCases) { (theme) in
					Text(LocalizedStringKey(theme.title))
						.tag(theme.rawValue)
				}
			}
		}
	}

	private var fontDesignStyle: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.textFormat, accent: .appOrange)
		} content: {
			Picker("settings.general.fontStyle", selection: $fontDesign) {
				ForEach(FontDesignType.allCases) { (design) in
					Text(LocalizedStringKey(design.title))
						.tag(design.rawValue)
				}
			}
		}
	}

	private var fontWidthStyle: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.arrowLeftRight, accent: .appYellow)
		} content: {
			Picker("settings.general.fontWidth", selection: $fontWidth) {
				ForEach(FontWidthType.allCases) { (width) in
					Text(LocalizedStringKey(width.title))
						.tag(width.rawValue)
				}
			}
		}
	}
}

struct AppearanceSettingsView_Previews: PreviewProvider {
	static var previews: some View {
		AppearanceScreen()
	}
}
