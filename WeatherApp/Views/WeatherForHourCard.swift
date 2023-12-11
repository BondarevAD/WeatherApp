//
//  WeatherForHourCard.swift
//  WeatherApp
//
//  Created by User on 8.12.23.
//

import SwiftUI

struct WeatherForHourCard: View {
    
    var list: List
    var language:Language
    
    var body: some View {
        VStack{
            Text(parseDate(unixTime: list.id, date: false))

            getImageByDescription( list.weather[0].icon)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            if(language.rawValue == "ru") {
                Text("\((String(format: "%.0f",list.main.temp)))°")
            }
            else {
                Text("\((String(format: "%.0f",list.main.temp)))F")

            }
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
