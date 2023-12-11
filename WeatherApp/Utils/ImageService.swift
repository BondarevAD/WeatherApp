//
//  ImageService.swift
//  WeatherApp
//
//  Created by User on 11.12.23.
//

import Foundation
import SwiftUI

func getImageByDescription(_ icon: String) -> Image {
    
    switch(icon) {
    case "11d","11n":
        return Image(systemName: "cloud.bolt")
    case "09d","09n":
        return Image(systemName: "cloud.heavyrain")
    case "10d","10n":
        return Image(systemName: "cloud.rain")
    case "13d", "13n":
        return Image(systemName: "snowflake")
    case "01d":
        return Image(systemName: "sun.max")
    case "01n":
        return Image(systemName: "moon")
    case "02d":
        return Image(systemName: "cloud.sun")
    case "02n":
        return Image(systemName: "cloud.moon")
    case "03d", "03n":
        return Image(systemName: "cloud")
    case "04d", "04n":
        return Image(systemName: "smoke")
    case "50d", "50n":
        return Image(systemName: "cloud.fog")
    default:
        return Image("Sun")
    }

}
