//
//  APITest.swift
//  CityBikeStationsDemoTests
//
//  Created by Stanislav Kimov on 16.03.23.
//

import XCTest
@testable import CityBikeStationsDemo

final class ApiTest: XCTestCase {
  func testDecodeData() throws {
    let expectation = self.expectation(description: "Stations count")
    Task {
      do {
        let mockApiClient = MockAPIClient()
        let network = try await mockApiClient.loadViennaNetwork()
        if network.stations.count == 231 {
          expectation.fulfill()
        }
      }
      catch let error as DetailedError  {
          XCTFail(error.message)
      }
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
}
