//
//  LocationService.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import CoreLocation

protocol LocationService {
  func getLocationOnce() async throws -> CLLocation
}
