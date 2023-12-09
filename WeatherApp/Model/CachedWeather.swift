//
//  CachedWeather.swift
//  WeatherApp
//
//  Created by User on 9.12.23.
//

import Foundation

struct CachedWeather: Codable {
    
    let weather: Welcome?
    let weatherForHours: WelcomeForHours?
    let weatherForWeeks: WelcomeForWeeks?
    let date: Date
    
}
