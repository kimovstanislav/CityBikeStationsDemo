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
class LocationServiceWrapper {
  var locationPublisher: AnyPublisher<Result<CLLocation?, Error>, Never> {
    locationSubject.eraseToAnyPublisher()
  }
  private let locationSubject = PassthroughSubject<Result<CLLocation?, Error>, Never>()
  
  private var bag = Set<AnyCancellable>()
  private var locationService = CombineLocationServiceClient()
  
  func updateLocation() {
    locationService.updateLocation()
  }
  
  init() {
    // Drop first to ignore initial not updated value
    // Send error only on restricted/denied authorization status
    locationService.$authorizationStatus
      .sink { [unowned self] currentStatus in
        print(">>> LocationServiceWrapper - authorizationStatus", currentStatus.rawValue)
        if currentStatus == .restricted || currentStatus == .denied {
          self.locationSubject.send(.failure(DetailedError.Factory.makeLocationServiceError()))
        }
      }.store(in: &bag)

    locationService.$currentLocation
      .dropFirst(1)
      .sink { [unowned self] currentLocation in
        print(">>> LocationServiceWrapper - currentLocation", currentLocation)
        self.locationSubject.send(.success(currentLocation))
      }.store(in: &bag)
  }
}

class CombineLocationServiceClient: NSObject {
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
extension CombineLocationServiceClient: CLLocationManagerDelegate {
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



// TODO: remove this implementation in ViewModel and tests and replace with a Combine one
// Currently this class was just quickly done for a single purpose, to be called once and forgotten.
actor LocationServiceClient: NSObject, LocationService {
  private var locationManager = CLLocationManager()
  
  typealias LocationClosure = (Result<CLLocation, Error>) -> Void
  private var completionHandler: LocationClosure?
  
  override init() {
    super.init()
    locationManager.delegate = self
  }
  
  func getLocationOnce() async throws -> CLLocation {
    guard completionHandler == nil else { throw DetailedError.unknown }
    return try await withCheckedThrowingContinuation { continuation in
    getLocationOnce { result in
        switch result {
        case .success(let location):
          continuation.resume(returning: location)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  private func getLocationOnce(completion: @escaping LocationClosure) {
    completionHandler = completion
    
    if !requestLocationOnceIfAllowed() {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  @discardableResult private func requestLocationOnceIfAllowed() -> Bool {
    if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
      locationManager.requestLocation()
      return true
    }
    return false
  }
  
  private func clearCompletion() {
    completionHandler = nil
  }
}

// MARK: - CLLocationManagerDelegate
extension LocationServiceClient: CLLocationManagerDelegate {
  nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    Task {
      await requestLocationOnceIfAllowed()
    }
  }
  
  nonisolated func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    if let location = locations.first {
      Task {
        await completionHandler?(.success(location))
        await clearCompletion()
      }
    }
  }
  
  nonisolated func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    Task {
      await completionHandler?(.failure(error))
      await clearCompletion()
    }
  }
}
