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

	init(vm: SettingsView.ViewModel = .init()) {
		_vm = StateObject(wrappedValue: vm)
	}

	var body: some View {
		NavigationView {
			Form {
				generalSection
				advancedSection
				devTeamSection
			}
			.navigationTitle("Settings")
			.sheet(isPresented: $isShowingOnboarding, content: {
				OnboardContainerView()
			})
			.confirmationDialog(
				"App settings would reset.\nThis action cannot be undone",
				isPresented: $vm.isConfirmingResetSettings,
				titleVisibility: .visible
			) {
				Button("Delete", role: .destructive) {
					vm.resetDefaults()
					haptic(.success)
				}
				Button("Cancel", role: .cancel) { }
			}
			.confirmationDialog(
				"All your tasks would be deleted.\nThis action cannot be undone",
				isPresented: $vm.isConfirmingResetUserData,
				titleVisibility: .visible
			) {
				Button("Delete", role: .destructive) {
					vm.resetAllTasks()
					haptic(.success)
				}
				Button("Cancel", role: .cancel) { }
			}
		}
	}
}

private extension SettingsView {
	private var generalSection: some View {
		Section {
			onboarding
			tabBadge
			portraitLock
			haptics
			appTheme
		} header: {
			HStack {
				SFSymbols.gearFilled
				Text("General")
			}
		} footer: {
			Text("App Version: \(vm.appVersionNumber) (\(vm.appBuildNumber))")
		}
	}

	private var tabBadge: some View {
		Toggle("Show Tab Badge", isOn: $vm.isShowingTabBadge)
			.tint(.accentColor)
	}

	private var portraitLock: some View {
		Toggle("Portrait Lock", isOn: $vm.isLockedInPortrait)
			.tint(.accentColor)
	}

	private var haptics: some View {
		Toggle(
			"Reduce Haptics",
			isOn: $vm.isHapticsReduced
		)
		.tint(.accentColor)
	}

	private var appTheme: some View {
		Picker("Color Theme", selection: $vm.systemTheme) {
			ForEach(SchemeType.allCases) { (theme) in
				Text(theme.title)
					.tag(theme.rawValue)
			}
		}
	}

	private var onboarding: some View {
		Button {
			isShowingOnboarding.toggle()
		} label: {
			Text("Show Onboarding screen")
		}
	}

	private var advancedSection: some View {
		Section {
			resetAppSettingsButton
			resetAppDataButton
		} header: {
			HStack {
				SFSymbols.magicWand
				Text("Advanced")
			}
		} footer: {
			Text("Be careful, these remove all your data! Restart the app to see all changes")
		}
	}

	private var resetAppSettingsButton: some View {
		Button(role: .destructive) {
			vm.isConfirmingResetSettings.toggle()
		} label: {
			Label {
				Text("Reset App Settings")
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
				Text("Reset Your Data")
			} icon: {
				SFSymbols.personFolder.foregroundColor(.red)
			}
		}
	}

	private var devTeamSection: some View {
		Section {
			HStack {
				SFSymbols.link
				Link("Joe Pham", destination: vm.joeGitHubLink)
			}

			HStack {
				SFSymbols.link
				Link("Marco Stevanella", destination: vm.marcoGitHubLink)
			}

			HStack {
				SFSymbols.link
				Link("Ostap Sulyk", destination: vm.ostapGitHubLink)
			}

			HStack {
				SFSymbols.link
				Link("Rauf Anata", destination: vm.raufGitHubLink)
			}
		} header: {
			HStack {
				SFSymbols.handsSparklesFilled
				Text("Meet The Team")
			}
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
