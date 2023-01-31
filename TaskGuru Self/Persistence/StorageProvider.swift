//
//  StorageProvider.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-30.
//

import CoreData

protocol StorageProvider {
	var context: NSManagedObjectContext { get }
	func fetch<T>() -> T
	func saveAndHandleError() -> Void
}

/// Implementation of a `StorageProvider` for a desired Core Data entity
final class StorageProviderImpl: StorageProvider {
	
	/// Singleton instance to use in the app
	static let standard: StorageProviderImpl = .init()
	
	private let container: NSPersistentContainer
	let context: NSManagedObjectContext
	
	private init() {
		container = .init(name: "TaskGuru")
		container.loadPersistentStores { (_, error) in
			if let error = error {
				fatalError("Core Data failed to load: \(error.localizedDescription)")
			}
		}
		context = container.viewContext
	}
	
	func fetch<T>() -> T {
		let fetchRequest: NSFetchRequest<CachedTask> = CachedTask.fetchRequest()
		// Sort fetch results by due date ascending, then last updated on top
		fetchRequest.sortDescriptors = [
			NSSortDescriptor(keyPath: \CachedTask.dueDate, ascending: true),
			NSSortDescriptor(keyPath: \CachedTask.lastUpdated, ascending: false)
		]
		return loadTasksAndHandleError(from: fetchRequest) as! T
	}
	
	fileprivate func loadTasksAndHandleError(from request: NSFetchRequest<CachedTask>) -> [CachedTask] {
		do {
			return try context.fetch(request)
		} catch let error {
			print("Error fetching books. \(error.localizedDescription)")
			return [CachedTask]()
		}
	}
	
	func saveAndHandleError() -> Void {
		do {
			if context.hasChanges {
				try context.save()
			}
		} catch let error {
			print("Error saving data. \(error.localizedDescription)")
		}
	}
}
