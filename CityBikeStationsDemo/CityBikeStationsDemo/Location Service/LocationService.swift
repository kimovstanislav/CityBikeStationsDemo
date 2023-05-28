//
//  LocationService.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import CoreLocation
import Combine

// TODO: remove the use of this protocol and replace with a Combine one
protocol LocationService {
  func getLocationOnce() async throws -> CLLocation
}

protocol CombineLocationService {
  var locationPublisher: AnyPublisher<Result<CLLocation?, Error>, Never> { get }
  func updateLocation()
}
