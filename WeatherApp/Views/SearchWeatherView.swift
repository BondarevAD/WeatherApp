//
//  SearchWeatherView.swift
//  WeatherApp
//
//  Created by User on 8.12.23.
//

import SwiftUI

struct SearchWeatherView: View {
    
    var weather: Welcome
    
    var body: some View {
        VStack{
            HStack{
                AsyncImage(url:
                            URL(string: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")!
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                } placeholder: {
                    ProgressView()
                }
                Text("\(String(format: "%2f", weather.main.temp))°")
                    .font(.system(size: 30))
            }
            Text(weather.name)
                .font(.system(size: 50))
                .fontWeight(.bold)
            Text(weather.weather[0].description)
            Spacer()
        }
    }
}


