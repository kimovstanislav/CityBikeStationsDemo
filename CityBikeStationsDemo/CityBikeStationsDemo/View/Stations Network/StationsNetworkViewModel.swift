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
  private let locationService: LocationService
  
  @Published @MainActor private(set) var viewState: ViewState = .idle
  
  private var network: Network?
  private var sortedStations: [Station] = []
  private var location: CLLocation?
  private var error: DetailedError?
  
  init(apiClient: API, locationService: LocationService) {
    self.apiClient = apiClient
    self.locationService = locationService
    super.init()
    start()
  }
  
  // Testing
//  let testLocationService = LocationServiceWrapper()
  
  private func start() {
//    testLocationService.updateLocation()
    
    Task {
      location = try? await locationService.getLocationOnce()
      if network != nil {
        updateViewState()
      }
    }
  }
}

// MARK: - Manage view state
extension StationsNetworkViewModel {
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
      if let error {
        await setViewState(.showError(errorMessage: error.message))
      }
      else if let network {
        let stations = sortedStations(network.stations)
        await setViewState(.showStations(stations: stations))
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
      clearError()
      startLoading()
      Task { [weak self] in
        guard let self else { return }
          do {
              let response = try await apiClient.loadViennaNetwork()
              self.handleGetNetworkSuccess(response)
          }
          catch let error as DetailedError {
              self.handleGetNetworkFailure(error)
          }
      }
    }
  
  private func clearError() {
    error = nil
  }
}

// MARK: - Handle API response
extension StationsNetworkViewModel {
    private func handleGetNetworkSuccess(_ result: Network) {
      network = result
      updateViewState()
    }
    
    private func handleGetNetworkFailure(_ apiError: DetailedError) {
      network = nil
      error = apiError
      updateViewState()
      processError(apiError)
    }
}

// MARK: - Sort stations logic
extension StationsNetworkViewModel {
  private func sortedStations(_ stations: [Station]) -> [Station] {
    if let location {
      return stations.sorted {
        $0.location.distance(from: location) < $1.location.distance(from: location)
      }
    }
    else {
      return stations.sorted { $0.name < $1.name }
    }
  }
}

// MARK: - Map url
extension StationsNetworkViewModel {
  func stationMapUrlFor(_ station: Station) -> URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "maps.apple.com"
    components.queryItems = [URLQueryItem(name: "ll", value: "\(station.latitude),\(station.longitude)")]
    guard let url = components.url else {
      unexpectedCodePath(message: "Failed to make station map url.")
    }
    return url
  }
}
