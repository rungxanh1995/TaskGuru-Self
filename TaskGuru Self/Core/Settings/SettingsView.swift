//
//  SettingsView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct SettingsView: View {
	@StateObject private var vm: ViewModel
	@State private var isShowingOnboarding: Bool = false

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

	init(vm: SettingsView.ViewModel = .init()) {
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
				acknowledgements
				appNameAndLogo
					.listRowBackground(Color.clear)
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					GradientNavigationTitle(text: "settings.nav.title")
				}
			}
			.sheet(isPresented: $isShowingOnboarding, content: {
				OnboardContainerView()
			})
			.confirmationDialog(
				"settings.advanced.resetSettings.alert",
				isPresented: $vm.isConfirmingResetSettings,
				titleVisibility: .visible
			) {
				Button("settings.advanced.resetSettings.delete", role: .destructive) {
					vm.resetDefaults()
					haptic(.success)
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
					haptic(.success)
				}
				Button("settings.advanced.resetUserData.cancel", role: .cancel) { }
			}
			.onChange(of: activeAppIcon) { iconName in
				UIApplication.shared.setAlternateIconName(iconName)
			}
		}
		.navigationViewStyle(.stack)
	}
}

private extension SettingsView {
	private var generalSection: some View {
		Section {
			onboarding
			appIcon
			portraitLock
			haptics
			appAccentColor
			fontDesignStyle
			appTheme
		} header: {
			Label { Text("settings.sections.general") } icon: { SFSymbols.gearFilled }
		}
	}

	private var appIcon: some View {
		Picker("settings.general.appIcon", selection: $activeAppIcon) {
			ForEach(vm.appIconNames, id: \.self) { iconName in
				Text(iconName).tag(iconName)
			}
		}
	}

	private var portraitLock: some View {
		Toggle("settings.general.portraitLock", isOn: $isLockedInPortrait)
			.tint(.accentColor)
	}

	private var haptics: some View {
		Toggle("settings.general.reduceHaptics", isOn: $isHapticsReduced)
			.tint(.accentColor)
	}

	private var appAccentColor: some View {
		Picker("settings.general.accentColor", selection: $accentColor) {
			ForEach(AccentColorType.allCases) { (accent) in
				Label {
					Text(LocalizedStringKey(accent.title))
				} icon: {
					SFSymbols.circleFilled
						.foregroundColor(accent.inbuiltColor)
				}
				.labelStyle(.titleAndIcon)
				.tag(accent.rawValue)
			}
		}
		.pickerStyle(.navigationLink)
	}

	private var fontDesignStyle: some View {
		Picker("settings.general.fontStyle", selection: $fontDesign) {
			ForEach(FontDesignType.allCases) { (design) in
				Text(LocalizedStringKey(design.title))
					.tag(design.rawValue)
			}
		}
	}

	private var appTheme: some View {
		Picker("settings.general.colorTheme", selection: $systemTheme) {
			ForEach(SchemeType.allCases) { (theme) in
				Text(LocalizedStringKey(theme.title))
					.tag(theme.rawValue)
			}
		}
	}

	private var onboarding: some View {
		Button {
			isShowingOnboarding.toggle()
		} label: {
			Text("settings.general.onboarding")
		}
	}

	private var badgeSection: some View {
		Section {
			appBadge
			appBadgeType
			tabBadge
		} header: {
			Label { Text("settings.sections.badge") } icon: { SFSymbols.appBadge }
		} footer: {
			Text("settings.badge.footer")
		}
	}

	private var appBadge: some View {
		Toggle("settings.badge.appIcon", isOn: $isShowingAppBadge)
			.tint(.accentColor)
	}

	private var appBadgeType: some View {
		Picker("settings.badge.appIconType", selection: $badgeType) {
			ForEach(BadgeType.allCases) { (type) in
				Text(LocalizedStringKey(type.title))
					.tag(type.rawValue)
			}
		}
		.disabled(!isShowingAppBadge)
	}

	private var tabBadge: some View {
		Toggle("settings.badge.tab", isOn: $isShowingTabBadge)
			.tint(.accentColor)
	}

	private var miscSection: some View {
		Section {
			tabNames
			confetti
			preview
			previewType.listRowSeparator(.hidden)
		} header: {
			Label { Text("settings.sections.misc") } icon: { SFSymbols.bubbleSparkles }
		} footer: {
			Text("settings.misc.footer")
		}
	}

	private var tabNames: some View {
		Toggle("settings.misc.tabNames", isOn: $isTabNamesEnabled)
			.tint(.accentColor)
	}

	private var confetti: some View {
		Toggle("settings.misc.confetti", isOn: $isConfettiEnabled)
			.tint(.accentColor)
	}

	private var preview: some View {
		Toggle("settings.misc.preview", isOn: $isPreviewEnabled)
			.tint(.accentColor)
	}

	private var previewType: some View {
		Picker("settings.misc.previewtype.title", selection: $contextPreviewType) {
			ForEach(ContextPreviewType.allCases) { (type) in
				Text(LocalizedStringKey(type.title))
					.tag(type.rawValue)
			}
		}
		.pickerStyle(.segmented)
		.disabled(!isPreviewEnabled)
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
		Button(role: .destructive) {
			vm.isConfirmingResetSettings.toggle()
		} label: {
			Label {
				Text("settings.advanced.resetSettings")
			} icon: {
				SFSymbols.gear.foregroundColor(.red)
			}
		}
	}

	private var resetAppDataButton: some View {
		Button(role: .destructive) {
			vm.isConfirmingResetUserData.toggle()
		} label: {
			Label {
				Text("settings.advanced.resetUserData")
			} icon: {
				SFSymbols.personFolder.foregroundColor(.red)
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
					.font(.system(.callout))
					.foregroundColor(.secondary)
				Spacer()
			}

			Image("app-logo")
				.resizable()
				.scaledToFit()
				.frame(width: 44, height: 44)
				.clipShape(RoundedRectangle(cornerRadius: 10))
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
