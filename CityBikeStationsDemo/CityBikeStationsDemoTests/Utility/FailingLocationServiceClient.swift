//
//  FailingLocationServiceClient.swift
//  CityBikeStationsDemoTests
//
//  Created by Stanislav Kimov on 16.03.23.
//

import Foundation
import CoreLocation
@testable import CityBikeStationsDemo

class FailingLocationServiceClient: LocationService {
  func getLocationOnce() async throws -> CLLocation {
    throw DetailedError.unknown
  }
}
