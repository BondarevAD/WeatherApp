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

    var body: some View {
        
        VStack{
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
                            
                            ScrollView(.vertical) {
                                HStack{
                                    AsyncImage(url:
                                                URL(string: "https://openweathermap.org/img/wn/\(viewModel.weather!.weather[0].icon)@2x.png")!
                                    ) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 70, height: 70)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    VStack{
                                        Text(viewModel.weather?.name ?? "None")
                                            .font(.system(size: 50))
                                        
                                            .fontWeight(.bold)
                                        
                                        Text(viewModel.weather?.weather[0].description ?? "")
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 10))
                                }
                                if(language.rawValue == "ru"){
                                    Text("\(String(format: "%.0f", viewModel.weather!.main.temp))°")
                                    
                                        .font(.system(size: 100))
                                        .frame(
                                            alignment: .center
                                        )
                                }else {
                                    Text("\(String(format: "%.0f", viewModel.weather!.main.temp))F")
                                    
                                        .font(.system(size: 100))
                                        .frame(
                                            alignment: .center
                                        )
                                }
                                Rectangle().fill(Color.gray).frame(maxWidth:.infinity,
                                                                   maxHeight: 1,
                                                                   alignment: .center).padding()
                                
                                ScrollView(.horizontal, showsIndicators: false){
                                    HStack{
                                        ForEach(viewModel.weatherForHours!.list[0...6]) {weather in
                                            WeatherForHourCard(list: weather, language: language)
                                        }
                                    }
                                }
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                
                                
                                ScrollView(.vertical){
                                    VStack{
                                        ForEach(viewModel.weatherForWeek!.daily) {weather in
                                            WeatherForWeekCard(weather: weather, language: language)
                                        }
                                    }
                                }
                                
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                
                                Spacer()
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
            .onAppear {
                observeCoordinatesUpdates()
                observeLocationAccessDenied()
                deviceLocationService.requestLocationUpdates()
                addLanguageObserver()
                Task{
                    await viewModel.loadWeather(for:coordinates)
                    await viewModel.loadWeatherForHours(for: self.coordinates)
                    await viewModel.loadWeatherForWeek(for: self.coordinates)
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
