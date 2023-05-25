//
//  LocationService.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import CoreLocation

// TODO: change into a Combine publisher
protocol LocationService {
  func getLocationOnce() async throws -> CLLocation
}
