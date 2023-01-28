//
//  Date.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-01-28.
//

import Foundation

extension Date {
	
	/// Returns true if the date is both within today but not passed today yet
	var isWithinToday: Bool {
		let oneDayInAdvanceInSeconds: TimeInterval = -(60*60*24)
		return self < Date.now && self > Date(timeIntervalSinceNow: oneDayInAdvanceInSeconds)
	}
}
