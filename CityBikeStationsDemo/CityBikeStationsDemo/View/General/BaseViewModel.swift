//
//  BaseViewModel.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
  @Published var alertModel: AlertViewModel = AlertViewModel()
  private var bag: Set<AnyCancellable> = []
  
  init() {
    alertModel.objectWillChange
      .sink { _ in
        self.objectWillChange.send()
      }
      .store(in: &bag)
  }
  
  @MainActor func showAlert(title: String, message: String) {
    alertModel.show(title: title, message: message)
  }
  
  func processError(_ error: DetailedError) {
    ErrorLogger.logError(error)
    if error.isSilent { return }
    Task {
      await showAlert(title: error.title, message: error.message)
    }
  }
}
