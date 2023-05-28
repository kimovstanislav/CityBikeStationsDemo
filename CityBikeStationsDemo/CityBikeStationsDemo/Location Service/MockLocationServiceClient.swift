//
//  MockLocationServiceClient.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import CoreLocation
import Combine

class MockLocationServiceClient: LocationService {
  var locationPublisher: AnyPublisher<Result<CLLocation?, DetailedError>, Never> {
    locationSubject.eraseToAnyPublisher()
  }
  private let locationSubject = PassthroughSubject<Result<CLLocation?, DetailedError>, Never>()
  
  func updateLocation() {
    locationSubject.send(.success(MockValues.Location.viennaCenter))
  }
}

