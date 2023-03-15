//
//  String.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 15/3/23.
//

import Foundation

extension String {
	func capitalizingFirstLetter() -> String {
		return prefix(1).capitalized + dropFirst()
	}

	mutating func capitalizeFirstLetter() {
		self = self.capitalizingFirstLetter()
	}
}
