//
//  AlertViewModel.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation

// TODO: make sure UI update is on main thread
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

  @MainActor func hide() {
    showAlert = false
    clear()
  }
  
  private func clear() {
    title = ""
    message = ""
  }
}
