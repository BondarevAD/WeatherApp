//
//  SettingsView.swift
//  WeatherApp
//
//  Created by User on 8.12.23.
//

import SwiftUI
import FlagKit


struct SettingsView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("settings_language".localized(language))
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                Menu {
                    Button {
                        LocalizationService.shared.language = .russian
                    } label: {
                        Text("Русский")
                        flagBy(countryCode: "RU")
                    }
                    Button {
                        LocalizationService.shared.language = .english
                    } label: {
                        Text("English")
                        flagBy(countryCode: "GB")
                    }
                } label: {
                    Spacer()
                    flagBy(countryCode: language.userSymbol.uppercased())
                        .resizable()
                        .frame(width: 40, height: 40)
                }.padding()
            }
            Text("settings_language_footer".localized(language))
                .foregroundColor(.gray)
                .font(.headline)
                .padding(.leading)
            Spacer()
        }    }
}

private extension SettingsView {
    
    func flagBy(countryCode: String) -> Image {
        guard let flag = Flag(countryCode: countryCode) else {
            return Image(systemName: "questionmark.circle")
        }
        return Image(uiImage: flag.image(style: .circle))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
