//
//  WeatherForHoursView.swift
//  WeatherApp
//
//  Created by User on 9.12.23.
//

import SwiftUI

struct WeatherForHoursView: View {
    
    var weather: WelcomeForHours
    var language: Language
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(weather.list[0...6]) {weather in
                    WeatherForHourCard(list: weather, language: language)
                }
            }
        }
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
    }
}

