//
//  WeatherForCityView.swift
//  WeatherApp
//
//  Created by User on 9.12.23.
//

import SwiftUI

struct WeatherForCityView: View {
    
    var weather: Welcome
    var language: Language
    
    var body: some View {
        
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
            VStack{
                Text(weather.name)
                    .font(.system(size: 50))
                
                    .fontWeight(.bold)
                
                Text(weather.weather[0].description)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 10))
        }
        
        if(language.rawValue == "ru"){
            Text("\(String(format: "%.0f", weather.main.temp))°")
            
                .font(.system(size: 100))
                .frame(
                    alignment: .center
                )
        }else {
            Text("\(String(format: "%.0f", weather.main.temp))F")
            
                .font(.system(size: 100))
                .frame(
                    alignment: .center
                )
        }
        Rectangle().fill(Color.gray).frame(maxWidth:.infinity,
                                           maxHeight: 1,
                                           alignment: .center).padding()
    }
}
