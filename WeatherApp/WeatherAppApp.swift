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
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
