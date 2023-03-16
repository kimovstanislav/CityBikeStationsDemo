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
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testLoadNetworkStations() throws {
    let expectation = self.expectation(description: "States")
    Task {
      do {
        let apiClient = MockAPIClient()
        let locationService = MockLocationServiceClient()
        let network = try await apiClient.loadViennaNetwork()
        let location = try await locationService.getLocationOnce()
        let toCompareStations = network.stations.sorted {
          $0.location.distance(from: location) < $1.location.distance(from: location)
        }
        var statesQueue = Queue<StationsNetworkViewModel.ViewState>()
        statesQueue.enqueue(.idle)
        statesQueue.enqueue(.loading)
        statesQueue.enqueue(.showStations(stations: toCompareStations))
        
        let viewModel = StationsNetworkViewModel(apiClient: apiClient, locationService: locationService)
        viewModel.loadNetworkStations()
        
        let _ = viewModel.$viewState
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
      }
      catch let error as DetailedError  {
        XCTFail(error.message)
      }
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
}

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

extension Station: Equatable {
  public static func == (lhs: CityBikeStationsDemo.Station, rhs: CityBikeStationsDemo.Station) -> Bool {
    lhs.id == rhs.id
  }
}