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
			.navigationBarTitle("settings.ack.nav.title")
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
			Text("settings.ack.devTeam")
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
			Text("settings.ack.localization")
				.font(.title3).bold()
				.foregroundColor(.defaultAccentColor)
			Text("settings.ack.localization.subtitle")
				.padding(.bottom)

			translationFor("ack.localization.azerbaijani", translators: "Rauf Anata")
			translationFor("ack.localization.chineseSim", translators: "Joe Pham")
			translationFor("ack.localization.italian", translators: "Marco Stevanella")
			translationFor("ack.localization.ukrainian", translators: "Ostap Sulyk")
			translationFor("ack.localization.vietnamese", translators: "Joe Pham")
		}
	}

	private var dependencies: some View {
		Group {
			Text("settings.ack.dependencies")
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
			Text("settings.ack.license")
				.font(.title3).bold()
				.foregroundColor(.defaultAccentColor)
			Text("settings.ack.license.content")
		}
	}
}

struct AcknowledgementsView_Previews: PreviewProvider {
	static var previews: some View {
		AcknowledgementsView()
	}
}
