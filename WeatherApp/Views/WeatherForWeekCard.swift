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
           
            getImageByDescription( weather!.weather[0].icon)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            
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

