//
//  DeviceLocationService.swift
//  WeatherApp
//
//  Created by User on 7.12.23.
//

import Foundation
import CoreLocation
import Combine

class DeviceLocationService:NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
    
    var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()
    
    private override init() {
        super.init()
    }
    
    static let shared = DeviceLocationService()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        coordinatesPublisher.send(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinatesPublisher.send(completion: .failure(error))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
            deniedLocationAccessPublisher.send()
        }
    }
    
    func requestLocationUpdates() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        default:
            deniedLocationAccessPublisher.send()
        }
    }
}
