//
//  DetailScreen.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

struct DetailScreen: View {
	@ObservedObject var vm: DetailScreen.ViewModel

	var body: some View {
		DetailScreen.ViewMode(vm: vm)
	}
}

struct DetailView_Previews: PreviewProvider {
	static var previews: some View {
		DetailScreen(vm: .init(for: dev.task))
	}
}
