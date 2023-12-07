//
//  ViewModelLists.swift
//  WeatherApp
//
//  Created by User on 7.12.23.
//


import Combine
import Foundation

class ViewModelList: ObservableObject {
  
  @Published var viewModels: [WeatherViewModel] = []
    
  var notificationCancelables: Set<AnyCancellable> = []
  
  private var language = LocalizationService.shared.language
  
  func addLanguageObserver() {
      NotificationCenter
        .default
        .publisher(for: LocalizationService.changedLanguage)
        .sink { [weak self] _ in
               guard let strongSelf = self else {
                 return
               }
               strongSelf.language = LocalizationService.shared.language
            
               let viewModels = [WeatherViewModel(language: strongSelf.language),
                                WeatherViewModel(language: strongSelf.language)]
               
                DispatchQueue.main.async {
                    strongSelf.viewModels = viewModels
                }
            }
            .store(in: &notificationCancelables)
  }
}
