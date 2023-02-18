//
//  AppState.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-17.
//

import SwiftUI

final class AppState: ObservableObject {
	@Published var navPath: NavigationPath = .init()
	
	/// Clears the navigation path, so the current view pops to its root view.
	func popToRoot() {
		navPath.removeLast(navPath.count)
	}
}
