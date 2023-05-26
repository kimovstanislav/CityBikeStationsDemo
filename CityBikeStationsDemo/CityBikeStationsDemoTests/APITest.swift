//
//  APITest.swift
//  CityBikeStationsDemoTests
//
//  Created by Stanislav Kimov on 16.03.23.
//

import XCTest
@testable import CityBikeStationsDemo

final class ApiTest: XCTestCase {
  func testDecodeData() async throws {
    let mockApiClient = MockAPIClient()
    let network = try await mockApiClient.loadViennaNetwork()
    XCTAssertEqual(network.stations.count, 231)
  }
}
