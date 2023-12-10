//
//  DateDiffrence.swift
//  WeatherApp
//
//  Created by User on 10.12.23.
//

import Foundation

func getDateDiffrence(date: Date) -> String {
    var nowDate = Date()
    
    
    let calendar = Calendar.current
    let hourNow = calendar.component(.hour, from: nowDate)
    let hour = calendar.component(.hour, from: date)
    let minutesNow = calendar.component(.minute, from: nowDate)
    let minutes = calendar.component(.hour, from: date)
    
    
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    var dateNowString = dateFormatter.string(from: nowDate)
    var dateString = dateFormatter.string(from: date)
    
    
    
    switch(hourNow - hour) {
    case 0:
        if(dateNowString == dateString) {
            return "\(minutes - minutesNow)" + "m".localized(LocalizationService.shared.language)
        }
        else {
            return ">1" + "d".localized(LocalizationService.shared.language)
        }
    case 1:
        if(60 + minutesNow - minutes >= 60) {
            return "\(hourNow - hour)" + "h".localized(LocalizationService.shared.language)
        }
        else {
            return "\(60 + minutesNow - minutes)" + "m".localized(LocalizationService.shared.language)
        }
    default:
        return "\(hourNow - hour)" + "h".localized(LocalizationService.shared.language)
    }
}
extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
