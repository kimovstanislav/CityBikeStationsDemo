//
//  FailingLocationServiceClient.swift
//  CityBikeStationsDemoTests
//
//  Created by Stanislav Kimov on 16.03.23.
//

import Foundation
import CoreLocation
import Combine
@testable import CityBikeStationsDemo

class FailingLocationServiceClient: LocationService {
  var locationPublisher: AnyPublisher<Result<CLLocation?, DetailedError>, Never> {
    locationSubject.eraseToAnyPublisher()
  }
  private let locationSubject = PassthroughSubject<Result<CLLocation?, DetailedError>, Never>()
  
  func updateLocation() {
    locationSubject.send(.failure(DetailedError.unknown))
  }
}
