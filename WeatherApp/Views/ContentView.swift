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
    @StateObject var viewModel = WeatherViewModel(language: LocalizationService.shared.language)
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
                if(cache.cachedData?.weather == nil) {
                    Text("no internet")
                }
                else {
                    Text(cache.cachedData!.weather!.name)
                }
            }
            else {
                if(viewModel.weather?.name == nil || viewModel.weatherForHours?.message == nil
                   || viewModel.weatherForWeek?.timezone == nil
                ) {
                    ProgressView()
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                }
                else{
                    VStack{
                        NavigationStack{
                            if(viewModel.searchedWeather?.name == nil || searchText == "")  {
                                ScrollView(.vertical){
                                    VStack{
                                        
                                        WeatherForCityView(weather: viewModel.weather!, language: language)
                                        
                                        WeatherForHoursView(weather: viewModel.weatherForHours!, language: language)
                                        
                                        WeatherForWeekView(weather: viewModel.weatherForWeek!, language: language)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            else {
                                if(viewModel.searchError?.message == nil && viewModel.searchedWeather?.name == nil) {
                                    ProgressView()
                                }
                                else{
                                    if(viewModel.searchError?.message != nil) {
                                        Text("City not founded.")
                                            .font(.system(size: 40))
                                    }
                                    else{
                                        SearchWeatherView(weather: viewModel.searchedWeather!, language: language)
                                    }
                                }
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: "city".localized(language))
                    .onSubmit(of: .search) {
                        Task{
                            await viewModel.searchWeather(for: searchText)
                        }
                    }
                    .onChange(of: searchText) { newValue in
                        if(newValue.count == 0) {
                            viewModel.clearSearch()
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
                        await viewModel.loadWeather(for:coordinates)
                        await viewModel.loadWeatherForHours(for: self.coordinates)
                        await viewModel.loadWeatherForWeek(for: self.coordinates)
                        if(viewModel.weather != nil)  {
                            var cachedWeather = CachedWeather(weather: viewModel.weather ?? nil, weatherForHours: viewModel.weatherForHours ?? nil, weatherForWeeks: viewModel.weatherForWeek ?? nil, date: Date())
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
                    await viewModel.loadWeather(for:self.coordinates)
                    await viewModel.loadWeatherForHours(for: self.coordinates)
                    await viewModel.loadWeatherForWeek(for: self.coordinates)
                    if(viewModel.weather != nil)  {
                        var cachedWeather = CachedWeather(weather: viewModel.weather ?? nil, weatherForHours: viewModel.weatherForHours ?? nil, weatherForWeeks: viewModel.weatherForWeek ?? nil, date: Date())
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
              viewModel.updateLanguage(language: LocalizationService.shared.language)
              
              Task{
                  await viewModel.loadWeather(for:self.coordinates)
                  await viewModel.loadWeatherForHours(for: self.coordinates)
                  await viewModel.loadWeatherForWeek(for: self.coordinates)
                  if(viewModel.weather != nil)  {
                      var cachedWeather = CachedWeather(weather: viewModel.weather ?? nil, weatherForHours: viewModel.weatherForHours ?? nil, weatherForWeeks: viewModel.weatherForWeek ?? nil, date: Date())
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
