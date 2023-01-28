//
//  HomeViewModel.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

extension HomeView {
	final class ViewModel: ObservableObject {
		@Published
		private(set) var personalTasks: [TaskItem] = .init()
		
		@Published
		private(set) var workTasks: [TaskItem] = .init()
		
		@Published
		private(set) var schoolTasks: [TaskItem] = .init()
		
		@Published
		private(set) var otherTasks: [TaskItem] = .init()
		
		@Published
		var isShowingAddTaskView: Bool = false
		
		// MARK: - CRUD Operations
		
		// ADD
		
		func addTask(name: inout String, type: TaskItem.TaskType, dueDate: Date,
					 status: TaskItem.TaskStatus, notes: String) -> Void {
			assignDefaultTaskName(to: &name)
			
			let newItem = TaskItem(name: name, type: type, dueDate: dueDate, status: status, notes: notes)
			addTask(newItem)
		}
		
		fileprivate func addTask(_ newItem: TaskItem) -> Void {
			switch newItem.type {
				case .personal:
					personalTasks.append(newItem)
				case .work:
					workTasks.append(newItem)
				case .school:
					schoolTasks.append(newItem)
				default:
					otherTasks.append(newItem)
			}
		}
		
		fileprivate func assignDefaultTaskName(to name: inout String) -> Void {
			if name == "" { name = "Untitled Task" }
		}
		
		// UPDATE
		
		func updateTasks(with item: TaskItem) -> Void {
			guard let index = getIndex(of: item) else { return }
			
			switch item.type {
				case .personal: personalTasks[index] = item
				case .work: workTasks[index] = item
				case .school: schoolTasks[index] = item
				default: otherTasks[index] = item
			}
		}
		
		fileprivate func getIndex(of item: TaskItem) -> Int? {
			switch item.type {
				case .personal: return personalTasks.firstIndex { $0.id == item.id }
				case .work: return workTasks.firstIndex { $0.id == item.id }
				case .school: return schoolTasks.firstIndex { $0.id == item.id }
				default: return otherTasks.firstIndex { $0.id == item.id }
			}
		}
		
		// DELETE
		func deletePersonalTasks(at offsets: IndexSet) -> Void {
			personalTasks.remove(atOffsets: offsets)
		}
		
		func deleteWorkTasks(at offsets: IndexSet) -> Void {
			workTasks.remove(atOffsets: offsets)
		}
		
		func deleteSchoolTasks(at offsets: IndexSet) -> Void {
			schoolTasks.remove(atOffsets: offsets)
		}
		
		func deleteOtherTasks(at offsets: IndexSet) -> Void {
			otherTasks.remove(atOffsets: offsets)
		}
	}
}
