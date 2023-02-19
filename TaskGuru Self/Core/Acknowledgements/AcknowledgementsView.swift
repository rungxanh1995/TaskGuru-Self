//
//  AcknowledgementsView.swift
//  TaskGuru Self
//
//  Created by Joe Pham on 2023-02-19.
//

import SwiftUI

struct AcknowledgementsView: View {
	var body: some View {
		ScrollView {
			VStack(alignment: .center) {
				developmentTeam
				Divider()
				localization
				Divider()
				dependencies
				Divider()
				license
			}
			.multilineTextAlignment(.center)
			.padding()
			.navigationBarTitle("Acknowledgements")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

extension AcknowledgementsView {
	@ViewBuilder
	private func translationFor(_ language: LocalizedStringKey, translators: String...) -> some View {
		VStack {
			Text(language).font(.headline)
			ForEach(translators, id: \.self) { Text($0) }
			Spacer()
		}
	}

	private var developmentTeam: some View {
		Group {
			Text("Development Team")
				.font(.title3).bold()
				.foregroundColor(.defaultAccentColor)
			Text("Joe Pham")
			Text("Marco Stevanella")
			Text("Ostap Sulyk")
			Text("Rauf Anata")
		}
	}

	private var localization: some View {
		Group {
			Text("Localization")
				.font(.title3).bold()
				.foregroundColor(.defaultAccentColor)
			Text("Many thanks to the amazing folks contributing to the translations for TaskGuru")

			Spacer()

			translationFor("Azerbaijani", translators: "Rauf Anata")
			translationFor("Chinese (Simplified)", translators: "Joe Pham")
			translationFor("Italian", translators: "Marco Stevanella")
			translationFor("Ukrainian", translators: "Ostap Sulyk")
			translationFor("Vietnamese", translators: "Joe Pham")
		}
	}

	private var dependencies: some View {
		Group {
			Text("Third Party Dependencies")
				.font(.title3).bold()
				.foregroundColor(.defaultAccentColor)
			Link(destination: URL(string: "https://github.com/simibac/ConfettiSwiftUI")!) {
				Text("ConfettiSwiftUI")
			}
			Text("Simon Bachmann")
		}
	}

	private var license: some View {
		Group {
			Text("License")
				.font(.title3).bold()
				.foregroundColor(.defaultAccentColor)
			Text("To be included after consulting with course instructor...")
				.italic()
		}
	}
}

struct AcknowledgementsView_Previews: PreviewProvider {
	static var previews: some View {
		AcknowledgementsView()
	}
}
