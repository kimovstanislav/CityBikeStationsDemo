//
//  LocationServiceClient.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import CoreLocation
import Combine

// Mock Vienna location - 48,210033 16,363449
/// Will publish a single location value or error on call to updateLocation()
class LocationServiceClient: LocationService {
  var locationPublisher: AnyPublisher<Result<CLLocation?, DetailedError>, Never> {
    locationSubject.eraseToAnyPublisher()
  }
  private let locationSubject = PassthroughSubject<Result<CLLocation?, DetailedError>, Never>()
  
  private var bag = Set<AnyCancellable>()
  private let locationService = CombineLocationService()
  
  func updateLocation() {
    locationService.updateLocation()
  }
  
  init() {
    // Send error only on restricted/denied authorization status
    locationService.$authorizationStatus
      .sink { [unowned self] currentStatus in
        if currentStatus == .restricted || currentStatus == .denied {
          self.locationSubject.send(.failure(DetailedError.Factory.makeLocationServiceError()))
        }
      }.store(in: &bag)

    // Drop first to ignore initial not updated value
    locationService.$currentLocation
      .dropFirst(1)
      .sink { [unowned self] currentLocation in
        self.locationSubject.send(.success(currentLocation))
      }.store(in: &bag)
  }
}

class CombineLocationService: NSObject {
  @Published private(set) var currentLocation: CLLocation? = nil
  @Published private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
  
  var errorPublisher: AnyPublisher<Error, Never> {
    errorSubject.eraseToAnyPublisher()
  }
  private let errorSubject = PassthroughSubject<Error, Never>()
  
  private let locationManager: CLLocationManager = CLLocationManager()
  
  override init() {
    super.init()
    locationManager.delegate = self
  }
  
  func updateLocation() {
    if !requestLocationIfAllowed() {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  @discardableResult private func requestLocationIfAllowed() -> Bool {
    if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
      locationManager.requestLocation()
      return true
    }
    return false
  }
}

// MARK: - CLLocationManagerDelegate
extension CombineLocationService: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationStatus = manager.authorizationStatus
    updateLocation()
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    if let location = locations.first {
      currentLocation = location
    }
  }
  
  nonisolated func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    currentLocation = nil
    errorSubject.send(error)
  }
}
