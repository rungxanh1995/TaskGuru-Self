//
//  SettingsView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct SettingsView: View {
	@StateObject
	private var vm: ViewModel
	
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
			.confirmationDialog(
				"This action cannot be undone",
				isPresented: $vm.isConfirmingResetData,
				titleVisibility: .visible
			) {
				Button("Delete", role: .destructive) {
					vm.resetData()
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
			haptics
			appTheme
		} header: {
			HStack {
				SFSymbols.gearFilled
				Text("General")
			}
		}
	}
	
	private var haptics: some View {
		Toggle(
			"Enable Haptics",
			isOn: $vm.isHapticsEnabled
		)
		.tint(Color.accentColor)
	}
	
	private var appTheme: some View {
		Picker("Color Theme", selection: $vm.systemTheme) {
			ForEach(SchemeType.allCases) { (theme) in
				Text(theme.title)
					.tag(theme.rawValue)
			}
		}
	}
	
	private var advancedSection: some View {
		Section {
			resetAppButton
		} header: {
			HStack {
				SFSymbols.magicWand
				Text("Advanced")
			}
		} footer: {
			Text("Be careful, this removes all your data! Restart the app to see all changes")
		}
	}
	
	private var resetAppButton: some View {
		Button("Reset to Original", role: .destructive) {
			vm.isConfirmingResetData.toggle()
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
