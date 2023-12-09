//
//  Cache.swift
//  WeatherApp
//
//  Created by User on 9.12.23.
//

import Foundation

class Cache: ObservableObject {
    
    private var cache: CachedWeather?
    
    var cachedData: CachedWeather?
    
    let userDefaults = UserDefaults.standard
    private let saveKey = "Cache"
    
    init() {
        let cache = userDefaults.value(forKey: saveKey) as? CachedWeather
        self.cache = cache ?? nil
        getCache()
    }
    
    func update(_ cache: CachedWeather) {
        objectWillChange.send()
        self.cache = cache
        save()
        print(cache)
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(cache) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
        getCache()
    }
    
    func getCache() {

        if let data = userDefaults.object(forKey: saveKey) as? Data,
           let newFavorites = try? JSONDecoder().decode(CachedWeather.self, from: data) {
             cache = newFavorites
        }
        cachedData = cache
    }
    
}
