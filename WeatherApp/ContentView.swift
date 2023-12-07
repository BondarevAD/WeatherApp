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
    
    
//    @StateObject var deviceLocationService = DeviceLocationService.shared
//
//    @State var tokens: Set<AnyCancellable> = []
//    @State var coordinates:(lat: Double, lon: Double) = (0,0)
    
    var body: some View {
        Text("Hello")
        }
//        .onAppear{
//            observeCoordinatesUpdates()
//            observeLocationAccessDenied()
//            deviceLocationService.requestLocationUpdates()
//        }
    }
    
//    func observeCoordinatesUpdates() {
//        deviceLocationService.coordinatesPublisher
//            .receive(on: DispatchQueue.main)
//            .sink{ completion in
//                if case .failure(let error) = completion {
//                    print(error)
//                }
//            }receiveValue: { coordinates in
//                self.coordinates = (coordinates.latitude, coordinates.longitude)
//            }
//            .store(in: &tokens)
//
//    }
//
//    func observeLocationAccessDenied() {
//        deviceLocationService.deniedLocationAccessPublisher
//            .receive(on: DispatchQueue.main)
//            .sink{
//                print("Show some kind of alert to user")
//            }
//            .store(in: &tokens)
//    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
