//
//  StationsNetworkViewModel+ViewState.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation

extension StationsNetworkViewModel {
  enum ViewState {
    case idle
    case loading
    case showNetwork(network: Network)
    case showError(errorMessage: String)
  }
}
