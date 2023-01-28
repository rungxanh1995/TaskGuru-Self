//
//  HomeView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

struct HomeView: View {
	private let personalTasks = ["Meditate", "Read books", "Do groceries"]
	private let workTasks = ["Complete Q3 reports", "Onboard new comers", "Review customer service stats"]
	private let schoolTasks = ["Research papers", "Prepping for exams", "Group project presentation"]
	
	@State
	var isShowingAddTask: Bool = false
	
    var body: some View {
		
		NavigationView {
			Form {
				Section(header: Text("Personal Tasks")) {
					ForEach(personalTasks, id:\.self) { task in
						NavigationLink(task) {
							DetailView(task: task)
						}
					}
				}
				
				Section(header: Text("Work Tasks")) {
					ForEach(workTasks, id:\.self) { task in
						NavigationLink(task) {
							DetailView(task: task)
						}
					}
				}
				
				Section(header: Text("School Tasks")) {
					ForEach(schoolTasks, id:\.self) { task in
						NavigationLink(task) {
							DetailView(task: task)
						}
					}
				}
			}
			.navigationTitle("TaskGuru")
			.toolbar {
				Button {
					// toggle adding new task view
					isShowingAddTask.toggle()
				} label: {
					Image(systemName: "plus.circle")
				}
			}
			.sheet(isPresented: $isShowingAddTask) {
				AddTask()
			}
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
			.preferredColorScheme(.dark)
    }
}
