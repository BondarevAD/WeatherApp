//
//  WeatherForWeek.swift
//  WeatherApp
//
//  Created by User on 8.12.23.
//
import Foundation

// MARK: - Welcome
struct WelcomeForWeeks: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current?
    let minutely: [Minutely]
    let hourly: [Current]
    let daily: [Daily]
//    let alerts: [Alert]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, minutely, hourly, daily
    }
}

// MARK: - Alert
struct Alert: Codable {
    let senderName, event: String
    let start, end: Int
    let description: String
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event, start, end, description, tags
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [WeatherForWeeks]
    let snow: Rain?
    let pop: Double?
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, snow, pop, rain
    }
}



// MARK: - Weather
struct WeatherForWeeks: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}



// MARK: - Daily
struct Daily: Codable, Identifiable {
    let id, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [WeatherForWeeks]
    let clouds: Int
    let pop: Double
    let rain, snow: Double?
    let uvi: Double

    enum CodingKeys: String, CodingKey {
        case  sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case id = "dt"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, rain, snow, uvi
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

// MARK: - Minutely
struct Minutely: Codable {
    let dt: Int
    let precipitation: Double
}
