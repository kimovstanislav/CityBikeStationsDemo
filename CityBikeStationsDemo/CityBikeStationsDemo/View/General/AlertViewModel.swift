//
//  AlertViewModel.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation

class AlertViewModel: ObservableObject {
  @Published @MainActor var showAlert = false {
    willSet {
      if newValue == false {
        clear()
      }
    }
  }
  
  var title: String = ""
  var message: String = ""

  @MainActor func show(title: String, message: String) {
    self.title = title
    self.message = message
    showAlert = true
  }
  
  private func clear() {
    title = ""
    message = ""
  }
}
