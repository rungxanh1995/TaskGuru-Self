//
//  SettingsViewModel.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

extension SettingsView {
	final class ViewModel: ObservableObject {
		@AppStorage(UserDefaultsKey.hapticsEnabled)
		var isHapticsEnabled: Bool = true
		
		@AppStorage(UserDefaultsKey.systemTheme)
		var systemTheme: Int = SchemeType.allCases.first!.rawValue
		
		@Published
		var isConfirmingResetData: Bool = false
		
		let joeGitHubLink: URL = URL(string: "https://twitter.com/rungxanh1995")!
		let marcoGitHubLink: URL = URL(string: "https://github.com/floydcoder")!
		let ostapGitHubLink: URL = URL(string: "https://github.com/ostap-sulyk")!
		let raufGitHubLink: URL = URL(string: "https://github.com/drrauf")!
		
		func resetData() {
			// TODO: Implement if possible
		}
	}
}
