//
//  WeatherView.swift
//  WeatherApp
//
//  Created by User on 10.12.23.
//

import SwiftUI

struct WeatherView: View {
    
    var viewModel: WeatherViewModel
    var language: Language
    var body: some View {
        ScrollView(.vertical){
            VStack{
                
                WeatherForCityView(weather: viewModel.weather!, language: language)
                
                WeatherForHoursView(weather: viewModel.weatherForHours!, language: language)
                
                WeatherForWeekView(weather: viewModel.weatherForWeek!, language: language)
                
                Spacer()
            }
        }
    }
}
