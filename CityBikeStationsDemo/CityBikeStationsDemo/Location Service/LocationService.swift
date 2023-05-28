//
//  LocationService.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import CoreLocation
import Combine

protocol LocationService {
  var locationPublisher: AnyPublisher<Result<CLLocation?, DetailedError>, Never> { get }
  func updateLocation()
}
