//
//  DetailView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

struct DetailView: View {
	@ObservedObject
	var vm: DetailView.ViewModel

    var body: some View {
		DetailView.ViewMode(vm: vm)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
		DetailView(vm: .init(for: dev.task))
    }
}
