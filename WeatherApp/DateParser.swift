//
//  DateParser.swift
//  WeatherApp
//
//  Created by User on 8.12.23.
//

import Foundation

func parseDate(unixTime: Int, date: Bool) -> String {
    let dateFormatter = DateFormatter()
    if(date) {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
    }
    else{
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
    }

    let formattedDate = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(unixTime)))

    return formattedDate
}
