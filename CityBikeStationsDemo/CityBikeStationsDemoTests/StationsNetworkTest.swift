//
//  StationsNetworkTest.swift
//  CityBikeStationsDemoTests
//
//  Created by Stanislav Kimov on 16.03.23.
//

import XCTest
import Combine
@testable import CityBikeStationsDemo

final class StationsNetworkTest: XCTestCase {
  private var bag: Set<AnyCancellable> = []
  
  let mockApiClient = MockAPIClient()
  let mockLocationService = MockLocationServiceClient()
  let failingApiClient = FailingAPIClient()
  let failingLocationService = FailingLocationServiceClient()
  
  override func setUpWithError() throws {
  }
  
  override func tearDownWithError() throws {
  }
  
  func testLoadStations() async throws {
    let expectation = self.expectation(description: "States")
    
    let viewModel = StationsNetworkViewModel(apiClient: mockApiClient, locationService: mockLocationService)
    
    let network = try await mockApiClient.loadViennaNetwork()
    let location = MockValues.Location.viennaCenter
    let loadedStations = network.stations.sorted {
      $0.location.distance(from: location) < $1.location.distance(from: location)
    }
    var statesQueue = Queue<StationsNetworkViewModel.ViewState>()
    statesQueue.enqueue(.idle)
    statesQueue.enqueue(.loading)
    statesQueue.enqueue(.showStations(stations: loadedStations))
    
    viewModel.$viewState
      .sink { value in
        let stateToCompare = statesQueue.dequeue()
        guard stateToCompare == value else {
          XCTFail("Wrong state")
          return
        }
        if statesQueue.isEmpty {
          expectation.fulfill()
        }
      }
      .store(in: &bag)
    
    viewModel.loadNetworkStations()
    
    wait(for: [expectation], timeout: 1)
  }
  
  func testLoadStationsNoLocation() async throws {
    let expectation = self.expectation(description: "States")
    
    let viewModel = StationsNetworkViewModel(apiClient: mockApiClient, locationService: failingLocationService)
    
    let network = try await mockApiClient.loadViennaNetwork()
    let loadedStations = network.stations.sorted { $0.name < $1.name }
    var statesQueue = Queue<StationsNetworkViewModel.ViewState>()
    statesQueue.enqueue(.idle)
    statesQueue.enqueue(.loading)
    statesQueue.enqueue(.showStations(stations: loadedStations))
    
    viewModel.$viewState
      .sink { value in
        let stateToCompare = statesQueue.dequeue()
        guard stateToCompare == value else {
          XCTFail("Wrong state")
          return
        }
        if statesQueue.isEmpty {
          expectation.fulfill()
        }
      }
      .store(in: &bag)
    
    viewModel.loadNetworkStations()
    
    wait(for: [expectation], timeout: 1)
  }
  
  func testLoadStationsFailureAlert() throws {
    let expectation = self.expectation(description: "Alert displayed")
    
    let viewModel = StationsNetworkViewModel(apiClient: failingApiClient, locationService: mockLocationService)
    
    viewModel.alertModel.$showAlert
      .sink { value in
        if value == true {
          expectation.fulfill()
        }
      }
      .store(in: &bag)
    
    viewModel.loadNetworkStations()
    
    wait(for: [expectation], timeout: 1)
  }
  
  func testLoadStationsSuccessNoAlert() throws {
    let expectation = self.expectation(description: "Alert displayed")
    expectation.isInverted = true
    
    let viewModel = StationsNetworkViewModel(apiClient: mockApiClient, locationService: mockLocationService)
    
    viewModel.alertModel.$showAlert
      .sink { value in
        if value == true {
          expectation.fulfill()
        }
      }
      .store(in: &bag)
    
    viewModel.loadNetworkStations()
    
    wait(for: [expectation], timeout: 1)
  }
}

// MARK: - ViewState Equatable
extension StationsNetworkViewModel.ViewState: Equatable {
  public static func ==(lhs: StationsNetworkViewModel.ViewState, rhs: StationsNetworkViewModel.ViewState) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle):
      return true
    case (.loading, .loading):
      return true
    case (let .showStations(stations1), let .showStations(stations2)):
      return stations1.sorted { a, b in a.id < b.id } == stations2.sorted { a, b in a.id < b.id }
    case (let .showError(error1), let .showError(error2)):
      return error1 == error2
    default:
      return false
    }
  }
}

// MARK: - Station Equatable
extension Station: Equatable {
  public static func == (lhs: Station, rhs: Station) -> Bool {
    lhs.id == rhs.id
  }
}
