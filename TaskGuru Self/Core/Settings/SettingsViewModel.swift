//
//  SettingsViewModel.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

extension SettingsScreen {
	final class ViewModel: ObservableObject {
		@Published var isConfirmingResetSettings: Bool = false
		@Published var isConfirmingResetUserData: Bool = false

		var appVersionNumber: String {
			Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
		}

		var appBuildNumber: String {
			Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
		}

		let joeGitHubLink: URL = URL(string: "https://twitter.com/rungxanh1995")!
		let marcoGitHubLink: URL = URL(string: "https://github.com/floydcoder")!
		let ostapGitHubLink: URL = URL(string: "https://github.com/ostap-sulyk")!
		let raufGitHubLink: URL = URL(string: "https://github.com/drrauf")!

		private let storageProvider: StorageProvider

		init(storageProvider: StorageProvider = StorageProviderImpl.standard) {
			self.storageProvider = storageProvider
		}

		func resetDefaults() {
			let defaults = UserDefaults.standard
			let dictionary = defaults.dictionaryRepresentation()
			dictionary.keys.forEach { defaults.removeObject(forKey: $0) }

			UIApplication.shared.setAlternateIconName(nil) // reset app icon
		}

		func resetAllTasks() {
			let allTasks: [TaskItem] = storageProvider.fetch()
			allTasks.forEach { storageProvider.context.delete($0) }
			storageProvider.saveAndHandleError()
		}
	}
}
