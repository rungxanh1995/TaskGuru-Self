//
//  PublisherObservableObject.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-15.
//	Tutorial by Antoine van der Lee
//	Link: https://www.avanderlee.com/swift/appstorage-explained/
//

import Combine

final class PublisherObservableObject: ObservableObject {
	var subscriber: AnyCancellable?

	init(publisher: AnyPublisher<Void, Never>) {
		subscriber = publisher.sink(receiveValue: { [weak self] _ in
			self?.objectWillChange.send()
		})
	}
}
