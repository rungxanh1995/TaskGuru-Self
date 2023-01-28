//
//  SettingsView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
		NavigationView {
			Form {
				Text("Settings item 1")
				Text("Settings item 2")
			}
			.navigationTitle("Settings")
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
