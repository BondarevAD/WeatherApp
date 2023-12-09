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
    @Published var weatherForHours: WelcomeForHours?
    @Published var weatherForWeek: WelcomeForWeeks?
    @Published var searchedWeather: Welcome?
    @Published var searchError: SearchError?
    
    var language: Language
    
    @MainActor func loadWeather(for coordinates:(lat: Double, lon: Double)) async  {
        let url: URL
        if(language.rawValue == "ru"){
            url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.lat)&lon=\(coordinates.lon)&appid=\(WeatherViewModel.apiKey)&units=metric&lang=ru")!
        }
        else{
            url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.lat)&lon=\(coordinates.lon)&appid=\(WeatherViewModel.apiKey)&units=imperial")!
        }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let weather = try JSONDecoder().decode(Welcome.self, from: data)
                self.weather = weather
//                print(weather)
            } catch {
                print(error)
            }
    }
    
    @MainActor func loadWeatherForHours(for coordinates:(lat: Double, lon: Double)) async  {
        
        let url: URL
        if(language.rawValue == "ru"){
            url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinates.lat)&lon=\(coordinates.lon)&appid=\(WeatherViewModel.apiKey)&units=metric&lang=ru")!
        }
        else{
            url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinates.lat)&lon=\(coordinates.lon)&appid=\(WeatherViewModel.apiKey)&units=imperial")!
        }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let weatherForHours = try JSONDecoder().decode(WelcomeForHours.self, from: data)
                self.weatherForHours = weatherForHours
//                print(weatherForHours)
            } catch {
                print(error)
            }
    }
    
    @MainActor func searchWeather(for searchCity: String) async {
        if let encodedCity = searchCity.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            var urlString = ""
            if language.rawValue == "ru" {
                urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(WeatherViewModel.apiKey)&lang=ru&units=metric"
            } else {
                urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(WeatherViewModel.apiKey)&units=imperial"
            }
                if let url = URL(string: urlString) {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let weather = try JSONDecoder().decode(Welcome.self, from: data)
                        self.searchedWeather = weather
                        self.searchError = nil
                    } catch {
                        print(error)
                        
                        do {
                            let (data, _) = try await URLSession.shared.data(from: url)
                            let error = try JSONDecoder().decode(SearchError.self, from: data)
                            self.searchError = error
                            self.searchedWeather = nil
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
        
        @MainActor func loadWeatherForWeek(for coordinates:(lat: Double, lon: Double)) async  {
            let url: URL
            if(language.rawValue == "ru"){
                url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.lat)&lon=\(coordinates.lon)&appid=\(WeatherViewModel.apiKey)&units=metric&lang=ru")!
            }
            else{
                url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.lat)&lon=\(coordinates.lon)&appid=\(WeatherViewModel.apiKey)&units=imperial")!
            }
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let weatherForWeek = try JSONDecoder().decode(WelcomeForWeeks.self, from: data)
                    self.weatherForWeek = weatherForWeek
//                    print(weatherForWeek)
                } catch {
                    print(error)
                }
        }
    
    func clearSearch() {
        self.searchedWeather = nil
        self.searchError = nil
    }
    
    func updateLanguage(language: Language) {
        self.language = language
    }
        
    
    
    
    init(language: Language) {
        self.language = language
    }
    
}
