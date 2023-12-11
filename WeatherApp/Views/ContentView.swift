//
//  ContentView.swift
//  WeatherApp
//
//  Created by User on 7.12.23.
//
import Combine
import SwiftUI
import CoreData
import CoreLocation


struct ContentView: View {
    @StateObject var viewModelRu = WeatherViewModel(language: Language(rawValue: "ru")!)
    @StateObject var viewModelEn = WeatherViewModel(language: Language(rawValue: "en")!)
    @State var searchText = ""
    
    @StateObject var deviceLocationService = DeviceLocationService.shared
    
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates:(lat: Double, lon: Double) = (0,0)
    
    @State var networkMonitor = NetworkMonitor()
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var cache: Cache

    var body: some View {
        
        VStack{
            if(networkMonitor.isConnected == false) {
                if(cache.cachedDataRu?.weather == nil) {
                    Text("no internet")
                }
                else {
                    ScrollView(.vertical) {
                        VStack{
                            
                            Text("\("no internet warning".localized(language)) \(getDateDiffrence(date: cache.cachedDataRu!.date)) \("ago".localized(language))")
                                .foregroundColor(Color(.gray))
                            
                            
                            if(language.rawValue == "ru") {
                                WeatherForCityView(weather: cache.cachedDataRu!.weather!, language: language)
                                
                                WeatherForHoursView(weather: cache.cachedDataRu!.weatherForHours!, language: language)
                                
                                WeatherForWeekView(weather: cache.cachedDataRu!.weatherForWeeks!, language: language)
                            }
                            else {
                                WeatherForCityView(weather: cache.cachedDataEn!.weather!, language: language)
                                
                                WeatherForHoursView(weather: cache.cachedDataEn!.weatherForHours!, language: language)
                                
                                WeatherForWeekView(weather: cache.cachedDataEn!.weatherForWeeks!, language: language)
                            }
                        }
                    }
                }
            }
            else {
                if(viewModelRu.weather?.name == nil || viewModelRu.weatherForHours?.message == nil
                   || viewModelRu.weatherForWeek?.timezone == nil || viewModelEn.weather?.name == nil || viewModelEn.weatherForHours?.message == nil
                   || viewModelEn.weatherForWeek?.timezone == nil
                ) {
                    ProgressView()
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                }
                else{
                    if(language.rawValue == "ru") {
                        VStack{
                            NavigationStack{
                                if(viewModelRu.searchedWeather?.name == nil || searchText == "")  {
                                    WeatherView(viewModel: viewModelRu, language: language)
                                }
                                else {
                                    if(viewModelRu.searchError?.message == nil && viewModelRu.searchedWeather?.name == nil) {
                                        ProgressView()
                                    }
                                    else{
                                        if(viewModelRu.searchError?.message != nil) {
                                            Text("City not founded.")
                                                .font(.system(size: 40))
                                        }
                                        else{
                                            SearchWeatherView(weather: viewModelRu.searchedWeather!, language: language)
                                        }
                                    }
                                }
                            }
                        }
                        .searchable(text: $searchText, prompt: "city".localized(language))
                        .onSubmit(of: .search) {
                            Task{
                                if(language.rawValue == "ru") {
                                    await viewModelRu.searchWeather(for: searchText)
                                }
                                else {
                                    await viewModelEn.searchWeather(for: searchText)
                                }
                            }
                        }
                        .onChange(of: searchText) { newValue in
                            if(newValue.count == 0) {
                                viewModelEn.clearSearch()
                                viewModelRu.clearSearch()
                            }
                        }
                    }
                    else {
                        VStack{
                            NavigationStack{
                                if(viewModelEn.searchedWeather?.name == nil || searchText == "")  {
                                    WeatherView(viewModel: viewModelEn, language: language)
                                }
                                else {
                                    if(viewModelEn.searchError?.message == nil && viewModelEn.searchedWeather?.name == nil) {
                                        ProgressView()
                                    }
                                    else{
                                        if(viewModelEn.searchError?.message != nil) {
                                            Text("City not founded.")
                                                .font(.system(size: 40))
                                        }
                                        else{
                                            SearchWeatherView(weather: viewModelEn.searchedWeather!, language: language)
                                        }
                                    }
                                }
                            }
                        }
                        .searchable(text: $searchText, prompt: "city".localized(language))
                        .onSubmit(of: .search) {
                            Task{
                                if(language.rawValue == "ru") {
                                    await viewModelRu.searchWeather(for: searchText)
                                }
                                else {
                                    await viewModelEn.searchWeather(for: searchText)
                                }
                            }
                        }
                        .onChange(of: searchText) { newValue in
                            if(newValue.count == 0) {
                                viewModelEn.clearSearch()
                                viewModelRu.clearSearch()
                            }
                        }
                    }
                        
                    
                }
                
                
                
                Spacer()
                
            }
        }
                .onAppear {
                    observeCoordinatesUpdates()
                    observeLocationAccessDenied()
                    deviceLocationService.requestLocationUpdates()
                    addLanguageObserver()
                    Task{
                        await viewModelRu.loadWeather(for:coordinates)
                        await viewModelRu.loadWeatherForHours(for: self.coordinates)
                        await viewModelRu.loadWeatherForWeek(for: self.coordinates)
                        await viewModelEn.loadWeather(for:coordinates)
                        await viewModelEn.loadWeatherForHours(for: self.coordinates)
                        await viewModelEn.loadWeatherForWeek(for: self.coordinates)
                        if(viewModelRu.weather != nil)  {
                            var cachedWeather = CachedWeather(weather: viewModelRu.weather ?? nil, weatherForHours: viewModelRu.weatherForHours ?? nil, weatherForWeeks: viewModelRu.weatherForWeek ?? nil, language: Language(rawValue: "ru")!, date: Date())
                            self.cache.update(cachedWeather)
                        }
                        if(viewModelEn.weather != nil)  {
                            var cachedWeather = CachedWeather(weather: viewModelEn.weather ?? nil, weatherForHours: viewModelEn.weatherForHours ?? nil, weatherForWeeks: viewModelEn.weatherForWeek ?? nil, language: Language(rawValue: "en")!, date: Date())
                            self.cache.update(cachedWeather)
                        }
                    }
                    
                }
            
        
    }
        

    
    func observeCoordinatesUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink{ completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            }receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
                Task{
                    await viewModelRu.loadWeather(for:self.coordinates)
                    await viewModelRu.loadWeatherForHours(for: self.coordinates)
                    await viewModelRu.loadWeatherForWeek(for: self.coordinates)
                    await viewModelEn.loadWeather(for:self.coordinates)
                    await viewModelEn.loadWeatherForHours(for: self.coordinates)
                    await viewModelEn.loadWeatherForWeek(for: self.coordinates)
                    if(viewModelRu.weather != nil)  {
                        var cachedWeather = CachedWeather(weather: viewModelRu.weather ?? nil, weatherForHours: viewModelRu.weatherForHours ?? nil, weatherForWeeks: viewModelRu.weatherForWeek ?? nil, language: Language(rawValue: "ru")!, date: Date())
                        self.cache.update(cachedWeather)
                    }
                    if(viewModelEn.weather != nil)  {
                        var cachedWeather = CachedWeather(weather: viewModelEn.weather ?? nil, weatherForHours: viewModelEn.weatherForHours ?? nil, weatherForWeeks: viewModelEn.weatherForWeek ?? nil, language: Language(rawValue: "en")!, date: Date())
                        self.cache.update(cachedWeather)
                    }
                }
                
            }
            .store(in: &tokens)
    }
    func observeLocationAccessDenied() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink{
                print("Show some kind of alert to user")
            }
            .store(in: &tokens)
    }
    func addLanguageObserver() {
        NotificationCenter
          .default
          .publisher(for: LocalizationService.changedLanguage)
          .sink { completion in
              if case .failure(let error) = completion {
                  print(error)
                }
          }receiveValue: { language in
              print(LocalizationService.shared.language)
              
              Task{
                  await viewModelRu.loadWeather(for:coordinates)
                  await viewModelRu.loadWeatherForHours(for: self.coordinates)
                  await viewModelRu.loadWeatherForWeek(for: self.coordinates)
                  await viewModelEn.loadWeather(for:coordinates)
                  await viewModelEn.loadWeatherForHours(for: self.coordinates)
                  await viewModelEn.loadWeatherForWeek(for: self.coordinates)
                  if(viewModelRu.weather != nil)  {
                      var cachedWeather = CachedWeather(weather: viewModelRu.weather ?? nil, weatherForHours: viewModelRu.weatherForHours ?? nil, weatherForWeeks: viewModelRu.weatherForWeek ?? nil, language: Language(rawValue: "ru")!, date: Date())
                      self.cache.update(cachedWeather)
                  }
                  if(viewModelEn.weather != nil)  {
                      var cachedWeather = CachedWeather(weather: viewModelEn.weather ?? nil, weatherForHours: viewModelEn.weatherForHours ?? nil, weatherForWeeks: viewModelEn.weatherForWeek ?? nil, language: Language(rawValue: "en")!, date: Date())
                      self.cache.update(cachedWeather)
                  }
              }
             
          }
              .store(in: &tokens)
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
