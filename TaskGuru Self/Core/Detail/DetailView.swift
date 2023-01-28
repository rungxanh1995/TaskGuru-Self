//
//  DetailView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import SwiftUI

struct DetailView: View {
	let task: TaskItem
	
	init(for task: TaskItem) { self.task = task }
	
    var body: some View {
		DetailView.ViewMode(task: task)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
		DetailView(for: dev.task)
    }
}
