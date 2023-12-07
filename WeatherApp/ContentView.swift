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
    
    
    @StateObject var deviceLocationService = DeviceLocationService.shared
    
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates:(lat: Double, lon: Double) = (0,0)
    

    
    var body: some View {
        
        HStack{
            Spacer()
            VStack{
                if(viewModel.weather?.name == nil) {
                    ProgressView()
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                }
                else{
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
                        
                    Text("\(String(format: "%.0f", viewModel.weather!.main.temp))°")
                        .font(.system(size: 100))
                        .frame(
                            alignment: .center
                        )
                    Rectangle().fill(Color.gray).frame(maxWidth:.infinity,
                                                       maxHeight: 1,
                                                       alignment: .center).padding()
                    Spacer()
                }
            }
            Spacer()
        }
        .onAppear {
            observeCoordinatesUpdates()
            observeLocationAccessDenied()
            deviceLocationService.requestLocationUpdates()
            Task{
                await viewModel.loadWeather(for:coordinates)
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
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
