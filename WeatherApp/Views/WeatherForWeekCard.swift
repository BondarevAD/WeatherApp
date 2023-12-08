//
//  WeatherForWeekCard.swift
//  WeatherApp
//
//  Created by User on 8.12.23.
//

import SwiftUI

struct WeatherForWeekCard: View {
    
    var weather: Daily?
    var language: Language
    
    var body: some View {
        HStack{
            Spacer()
            Text(parseDate(unixTime:weather!.id, date: true))
            Spacer()
            AsyncImage(url:
                        URL(string: "https://openweathermap.org/img/wn/\(weather?.weather[0].icon ?? "10d")@2x.png")!
            ) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }
            Spacer()
            if(language.rawValue == "ru") {
                Text("\(String(format: "%.0f",weather!.temp.day))°")
            }
            else {
                Text("\(String(format: "%.0f",weather!.temp.day))F")

            }
            Spacer()
            
        }
    }
}

