//
//  BaseViewModel.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation

class BaseViewModel: ObservableObject {
  @Published @MainActor var alertModel: AlertViewModel = AlertViewModel()
//  {
//    willSet {
//      self.objectWillChange.send()
//    }
//  }
  
  @MainActor func showAlert(title: String, message: String) {
    alertModel.show(title: title, message: message)
    self.objectWillChange.send()
  }

//  @MainActor func hideAlert() {
//    alertModel.hide()
//  }
  
  func processError(_ error: DetailedError) {
    ErrorLogger.logError(error)
    if error.isSilent { return }
    Task {
      await showAlert(title: error.title, message: error.message)
    }
  }
}
