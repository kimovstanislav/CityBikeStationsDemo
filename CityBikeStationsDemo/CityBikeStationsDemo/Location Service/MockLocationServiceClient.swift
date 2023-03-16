//
//  MockLocationServiceClient.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import CoreLocation

class MockLocationServiceClient: NSObject, LocationService {
  func getLocationOnce() async throws -> CLLocation {
    return CLLocation(latitude: 48.210033, longitude: 16.363449)
  }
}
