//
//  MockViewModelFactory.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation

class MockViewModelFactory {
  static let shared = MockViewModelFactory()
  
  private let apiClient = MockAPIClient()
  private let locationService = MockLocationServiceClient()
  
  func makeStationsNetworkViewModel() -> StationsNetworkViewModel {
    return StationsNetworkViewModel(apiClient: apiClient, locationService: locationService)
  }
}
