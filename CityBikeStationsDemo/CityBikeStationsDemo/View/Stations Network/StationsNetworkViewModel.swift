//
//  StationsNetworkViewModel.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import CoreLocation

class StationsNetworkViewModel: BaseViewModel {
  private let apiClient: API
  
  @Published @MainActor private(set) var viewState: ViewState = .idle
  
  private var network: Network? = nil
  private var location: CLLocation? = nil
//  private var error: DetailedError? = nil
  
  init(apiClient: API) {
      self.apiClient = apiClient
      super.init()
  }
  
  @MainActor private func setViewState(_ state: ViewState) {
    self.viewState = state
  }
  
  private func startLoading() {
    Task {
      await setViewState(.loading)
    }
  }
  
  private func updateViewState() {
    Task {
//      if let error = error {
//        await setViewState(.showError(errorMessage: error.message))
//      }
      if let network = network {
//        await self.processError(.unknown)
        await setViewState(.showNetwork(network: network))
      }
      else {
        await setViewState(.idle)
      }
    }
  }
}

// MARK: - Load from server
extension StationsNetworkViewModel {
    func loadNetworkStations() {
      startLoading()
      Task { [weak self] in
        guard let self else { return }
          do {
              let response = try await apiClient.loadViennaNetwork()
              self.handleGetNetworkSuccess(response)
          }
          catch let error as DetailedError  {
              self.handleGetNetworkFailure(error)
          }
      }
    }
}

// MARK: - Handle API response
extension StationsNetworkViewModel {
    private func handleGetNetworkSuccess(_ result: Network) {
//      error = nil
      network = result
      // TODO: perform the actual sorting and then pass sorted to the view
//      let sortedStations = sortStations(result.stations)
      updateViewState()
    }
    
    private func handleGetNetworkFailure(_ apiError: DetailedError) {
      network = nil
      updateViewState()
//      error = apiError
      processError(apiError)
    }
}

// MARK: - Sort stations logic
//extension StationsNetworkViewModel {
//  private func sortStations(_ stations: [Station]) -> [Station] {
//    return stations
//  }
//}
