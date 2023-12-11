//
//  SearchWeatherView.swift
//  WeatherApp
//
//  Created by User on 8.12.23.
//

import SwiftUI

struct SearchWeatherView: View {
    
    var weather: Welcome
    var language: Language
    
    var body: some View {
        VStack{
            HStack{
                getImageByDescription( weather.weather[0].icon)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                if(language.rawValue == "ru"){
                    Text("\(String(format: "%.0f", weather.main.temp))°")
                        .font(.system(size: 30))
                }
                else {
                    Text("\(String(format: "%.0f", weather.main.temp))F")
                        .font(.system(size: 30))
                }
            }
            Text(weather.name)
                .font(.system(size: 50))
                .fontWeight(.bold)
            Text(weather.weather[0].description)
            Spacer()
        }
    }
}


