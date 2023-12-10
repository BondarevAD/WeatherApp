//
//  Cache.swift
//  WeatherApp
//
//  Created by User on 9.12.23.
//

import Foundation

class Cache: ObservableObject {
    
    private var cacheRu: CachedWeather?
    private var cacheEn: CachedWeather?

    
    var cachedDataRu: CachedWeather?
    var cachedDataEn: CachedWeather?

    
    let userDefaults = UserDefaults.standard
    private let saveKeyRu = "CacheRu"
    private let saveKeyEn = "CacheEn"
    
    init() {
            let cacheRu = userDefaults.value(forKey: saveKeyRu) as? CachedWeather
            self.cacheRu = cacheRu ?? nil
            getCache(Language(rawValue: "ru")!)
    
      
            let cacheEn = userDefaults.value(forKey: saveKeyEn) as? CachedWeather
            self.cacheEn = cacheEn ?? nil
            getCache(Language(rawValue: "en")!)

    }
    
    func update(_ cache: CachedWeather) {
        if(cache.language.rawValue == "ru") {
            objectWillChange.send()
            self.cacheRu = cache
            save(cache.language)
            print(cache)
        }
        else {
            objectWillChange.send()
            self.cacheEn = cache
            save(cache.language)
            print(cache)
        }
    }

    func save(_ language: Language) {
        if(language.rawValue == "ru") {
            if let encoded = try? JSONEncoder().encode(cacheRu) {
                UserDefaults.standard.set(encoded, forKey: saveKeyRu)
            }
            getCache(language)
        }
        else {
            if let encoded = try? JSONEncoder().encode(cacheEn) {
                UserDefaults.standard.set(encoded, forKey: saveKeyEn)
            }
            getCache(language)
        }
    }
    
    func getCache(_ language: Language) {
        
        if(language.rawValue == "ru") {
            
            if let data = userDefaults.object(forKey: saveKeyRu) as? Data,
               let cacheRu = try? JSONDecoder().decode(CachedWeather.self, from: data) {
                self.cacheRu = cacheRu
            }
            cachedDataRu = cacheRu
        }
        else {
            if let data = userDefaults.object(forKey: saveKeyEn) as? Data,
               let cacheEn = try? JSONDecoder().decode(CachedWeather.self, from: data) {
                self.cacheEn = cacheEn
            }
            cachedDataEn = cacheEn
        }
    }
    
}
