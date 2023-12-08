//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by User on 7.12.23.
//

import SwiftUI
import CoreLocation

@main
struct WeatherAppApp: App {    

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(.blue)
                    }
                SettingsView()
                    .tabItem{
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.blue)
                    }
            }
        }
    }
}
