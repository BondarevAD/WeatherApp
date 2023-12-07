//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by User on 7.12.23.
//

import Foundation

class WeatherViewModel: ObservableObject {
    
    public static let apiKey = "18c116696f2d0dd430a18ed1393b1019"
    
    @Published var weather: Welcome?
    
    var language: Language
    
    func loadWeather(for coordinates:(lat: Double, lon: Double)) async  {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.lat)&lon=\(coordinates.lon)&appid=\(WeatherViewModel.apiKey)&units=metric")!
        print(url)
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let weather = try JSONDecoder().decode(Welcome.self, from: data)
                self.weather = weather
                print(weather)
            } catch {
                print(error)
            }
    }
    
    init(language: Language) {
        self.language = language
    }
    
}
