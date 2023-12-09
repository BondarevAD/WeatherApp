//
//  WeatherForWeekView.swift
//  WeatherApp
//
//  Created by User on 9.12.23.
//

import SwiftUI

struct WeatherForWeekView: View {
    
    var weather: WelcomeForWeeks
    var language: Language
    
    var body: some View {
        ScrollView(.vertical){
            VStack{
                ForEach(weather.daily) {weather in
                    WeatherForWeekCard(weather: weather, language: language)
                }
            }
        }
        
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
        
    }
}

