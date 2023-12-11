//
//  WeatherForHours.swift
//  WeatherApp
//
//  Created by User on 7.12.23.
//

import Foundation

// MARK: - Welcome
struct WelcomeForHours: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City?
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}


// MARK: - List
struct List: Codable, Identifiable {
    let id: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: SysForHours
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case id = "dt"
    }
}

// MARK: - MainClass
struct MainClass: Codable{
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain


// MARK: - Sys
struct SysForHours: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case snow = "Snow"
}

