//
//  WeatherForHourCard.swift
//  WeatherApp
//
//  Created by User on 8.12.23.
//

import SwiftUI

struct WeatherForHourCard: View {
    
    var list: List
    
    var body: some View {
        VStack{
            Text(parseDate(unixTime: list.id, date: false))

            AsyncImage(url:
                        URL(string: "https://openweathermap.org/img/wn/\(list.weather[0].icon)@2x.png")!
            ) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }
            
            Text("\((String(format: "%.0f",list.main.temp)))°")
        }
        .padding(.all)
        .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray, lineWidth: 2)
            )
        
    }
}

//struct WeatherForHourCard_Previews: PreviewProvider {
//    static var previews: some View {
//        WeatherForHourCard(list: List(dt: 1678716422, main: <#T##MainClass#>, weather: <#T##[Weather]#>, clouds: <#T##Clouds#>, wind: <#T##Wind#>, visibility: <#T##Int#>, pop: <#T##Double#>, sys: <#T##SysForHours#>, dtTxt: <#T##String#>, rain: <#T##Rain?#>, snow: <#T##Rain?#>))
//    }
//}
