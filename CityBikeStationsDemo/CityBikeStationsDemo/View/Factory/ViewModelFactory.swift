//
//  ViewModelFactory.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation

class ViewModelFactory {
  static let shared = ViewModelFactory()
  
  private let apiClient: API = APIClient()
  
  func makeStationsNetworkViewModel() -> StationsNetworkViewModel {
    return StationsNetworkViewModel(apiClient: apiClient)
  }
}
