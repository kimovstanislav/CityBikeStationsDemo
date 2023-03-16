//
//  FailingAPIClient.swift
//  CityBikeStationsDemoTests
//
//  Created by Stanislav Kimov on 16.03.23.
//

import Foundation
@testable import CityBikeStationsDemo

class FailingAPIClient: API {
  var failingError: DetailedError = DetailedError.Factory.makeDecodingError(cause: nil)
  
  func loadViennaNetwork() async throws -> Network  {
    throw failingError
  }
}
