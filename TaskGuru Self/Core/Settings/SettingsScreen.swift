//
//  SettingsScreen.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct SettingsScreen: View {
	@StateObject private var vm: ViewModel

	@Preference(\.isShowingAppBadge) private var isShowingAppBadge
	@Preference(\.isShowingTabBadge) private var isShowingTabBadge
	@Preference(\.isConfettiEnabled) private var isConfettiEnabled
	@Preference(\.isPreviewEnabled) private var isPreviewEnabled
	@Preference(\.isLockedInPortrait) private var isLockedInPortrait
	@Preference(\.isHapticsReduced) private var isHapticsReduced
	@Preference(\.isTabNamesEnabled) private var isTabNamesEnabled
	@Preference(\.activeAppIcon) private var activeAppIcon
	@Preference(\.accentColor) private var accentColor
	@Preference(\.fontDesign) private var fontDesign
	@Preference(\.systemTheme) private var systemTheme
	@Preference(\.badgeType) private var badgeType
	@Preference(\.contextPreviewType) private var contextPreviewType

	init(vm: SettingsScreen.ViewModel = .init()) {
		_vm = StateObject(wrappedValue: vm)
	}

	var body: some View {
		NavigationStack {
			Form {
				generalSection
				badgeSection
				miscSection
				advancedSection
				devTeamSection
				onboarding
				acknowledgements
				appNameAndLogo
					.listRowBackground(Color.clear)
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .principal) {
					NavigationTitle(text: "settings.nav.title")
				}
			}
			.confirmationDialog(
				"settings.advanced.resetSettings.alert",
				isPresented: $vm.isConfirmingResetSettings,
				titleVisibility: .visible
			) {
				Button("settings.advanced.resetSettings.delete", role: .destructive) {
					vm.resetDefaults()
					haptic(.notification(.success))
				}
				Button("settings.advanced.resetSettings.cancel", role: .cancel) { }
			}
			.confirmationDialog(
				"settings.advanced.resetUserData.alert",
				isPresented: $vm.isConfirmingResetUserData,
				titleVisibility: .visible
			) {
				Button("settings.advanced.resetUserData.delete", role: .destructive) {
					vm.resetAllTasks()
					haptic(.notification(.success))
				}
				Button("settings.advanced.resetUserData.cancel", role: .cancel) { }
			}
		}
		.navigationViewStyle(.stack)
	}
}

private extension SettingsScreen {
	/// Returns a horizontally stacked `View` that contains an `icon` and a settings `content`.
	///
	/// - Parameters:
	///   - icon: A closure that returns a `View` representing the icon to be displayed.
	///   - content: A closure that returns a `View` representing the content to be displayed.
	///
	/// - Returns: A horizontally stacked `View` that contains the `icon` and `content`.
	///
	private func settingsRow<Icon: View, Content: View>(
		@ViewBuilder icon: () -> Icon, @ViewBuilder content: () -> Content
	) -> some View {
		HStack(spacing: 16) {
			icon()
			content()
		}
	}

	private var generalSection: some View {
		Section {
			appIcon
			appAccentColor
			portraitLock
			haptics
			fontDesignStyle
			appTheme
		} header: {
			Label { Text("settings.sections.general") } icon: { SFSymbols.gearFilled }
		}
	}

	@ViewBuilder private var appIcon: some View {
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

	private var portraitLock: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.lockRotation, accent: .appIndigo)
		} content: {
			Toggle("settings.general.portraitLock", isOn: $isLockedInPortrait)
				.tint(.accentColor)
		}
	}

	private var haptics: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.waveform, accent: .appPink)
		} content: {
			Toggle("settings.general.reduceHaptics", isOn: $isHapticsReduced)
				.tint(.accentColor)
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

	private var appTheme: some View {
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

	private var badgeSection: some View {
		Section {
			tabBadge
			appBadge
			notifSettingLink
		} header: {
			Label { Text("settings.sections.badge") } icon: { SFSymbols.appBadge }
		} footer: {
			Text("settings.badge.footer")
		}
	}

	private var tabBadge: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.clockBadge, accent: .appPink)
		} content: {
			Toggle("settings.badge.tab", isOn: $isShowingTabBadge)
				.tint(.accentColor)
		}
	}

	private var appBadge: some View {
		VStack {
			settingsRow {
				SettingsIcon(icon: SFSymbols.appBadge, accent: .appPurple)
			} content: {
				Toggle("settings.badge.appIcon", isOn: $isShowingAppBadge)
					.tint(.accentColor)
			}
			Picker("settings.badge.appIconType", selection: $badgeType) {
				ForEach(BadgeType.allCases) { (type) in
					Text(LocalizedStringKey(type.title))
						.tag(type.rawValue)
				}
			}
			.disabled(!isShowingAppBadge)
		}
	}

	/// Guide user to System notification settings to manually allow permission for badge
	private var notifSettingLink: some View {
		HStack {
			let url = URL(string: UIApplication.openNotificationSettingsURLString)!
			Link("settings.badge.notifSetting", destination: url)
				.tint(.primary)
			Spacer()
			SFSymbols.arrowUpForward
				.foregroundColor(isShowingAppBadge ? .primary : .gray.opacity(0.5))
		}
		.disabled(!isShowingAppBadge)
	}

	private var miscSection: some View {
		Section {
			displayLanguage
			tabNames
			confetti
			preview
		} header: {
			Label { Text("settings.sections.misc") } icon: { SFSymbols.bubbleSparkles }
		} footer: {
			Text("settings.misc.footer")
		}
	}

	private var displayLanguage: some View {
		// hacky workaround for a stock look w/ disclosure indicator
		settingsRow {
			SettingsIcon(icon: SFSymbols.globe, accent: .appOrange)
		} content: {
			let url = URL(string: UIApplication.openSettingsURLString)!
			Link("settings.misc.language", destination: url)
				.tint(.primary)
			Spacer()
			SFSymbols.chevronRight.fontWeight(.medium)
				.foregroundColor(.gray.opacity(0.5))
		}
	}

	private var tabNames: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.dock, accent: .appBlue)
		} content: {
			Toggle("settings.misc.tabNames", isOn: $isTabNamesEnabled)
				.tint(.accentColor)
		}
	}

	private var confetti: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.sparkles, accent: .appPink)
		} content: {
			Toggle("settings.misc.confetti", isOn: $isConfettiEnabled)
				.tint(.accentColor)
		}
	}

	private var preview: some View {
		VStack {
			settingsRow {
				SettingsIcon(icon: SFSymbols.handTap, accent: .appIndigo)
			} content: {
				Toggle("settings.misc.preview", isOn: $isPreviewEnabled)
					.tint(.accentColor)
			}
			Picker("settings.misc.previewtype.title", selection: $contextPreviewType) {
				ForEach(ContextPreviewType.allCases) { (type) in
					Text(LocalizedStringKey(type.title))
						.tag(type.rawValue)
				}
			}
			.pickerStyle(.segmented)
			.disabled(!isPreviewEnabled)
		}
	}

	private var advancedSection: some View {
		Section {
			resetAppSettingsButton
			resetAppDataButton
		} header: {
			Label { Text("settings.sections.advanced") } icon: { SFSymbols.magicWand }
		} footer: {
			Text("settings.advanced.footer")
		}
	}

	private var resetAppSettingsButton: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.gear, accent: .red)
		} content: {
			Button(role: .destructive) {
				vm.isConfirmingResetSettings.toggle()
			} label: {
				Text("settings.advanced.resetSettings")
			}
		}
	}

	private var resetAppDataButton: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.personFolder, accent: .red)
		} content: {
			Button(role: .destructive) {
				vm.isConfirmingResetUserData.toggle()
			} label: {
				Text("settings.advanced.resetUserData")
			}
		}
	}

	private var devTeamSection: some View {
		Section {
			Label {
				Link("Joe Pham", destination: vm.joeGitHubLink)
			} icon: { SFSymbols.link }

			Label {
				Link("Marco Stevanella", destination: vm.marcoGitHubLink)
			} icon: { SFSymbols.link }

			Label {
				Link("Ostap Sulyk", destination: vm.ostapGitHubLink)
			} icon: { SFSymbols.link }

			Label {
				Link("Rauf Anata", destination: vm.raufGitHubLink)
			} icon: { SFSymbols.link }
		} header: {
			Label { Text("settings.sections.devTeam") } icon: { SFSymbols.handsSparklesFilled }
		}
	}

	private var onboarding: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.handWave, accent: .defaultAccentColor)
		} content: {
			NavigationLink("settings.general.onboarding") {
				OnboardContainerView()
			}
		}
	}

	private var acknowledgements: some View {
		Section {
			NavigationLink("settings.sections.ack") {
				AcknowledgementsView()
			}
		}
	}

	private var appNameAndLogo: some View {
		VStack(spacing: 8) {
			HStack {
				Spacer()
				Text("TaskGuru \(vm.appVersionNumber) (\(vm.appBuildNumber))")
					.font(.callout)
					.foregroundColor(.secondary)
				Spacer()
			}

			if let icon = AppIconType(rawValue: activeAppIcon)?.iconImage {
				icon.asIconSize()
			} else {
				Image("app-logo").asIconSize()
			}
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsScreen()
	}
}
