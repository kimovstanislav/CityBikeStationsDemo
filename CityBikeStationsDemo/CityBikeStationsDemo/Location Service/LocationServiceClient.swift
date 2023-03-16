//
//  LocationServiceClient.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import CoreLocation

actor LocationServiceClient: NSObject, LocationService {
  private var locationManager = CLLocationManager()
  
  typealias LocationClosure = (Result<CLLocation, Error>) -> Void
  private var completionHandler: LocationClosure? = nil
  
  override init() {
    super.init()
    locationManager.delegate = self
  }
  
  func getLocationOnce() async throws -> CLLocation {
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
}

// MARK: - CLLocationManagerDelegate
extension LocationServiceClient: CLLocationManagerDelegate {
  nonisolated func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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
      }
    }
  }
  
  nonisolated func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    Task {
      await completionHandler?(.failure(error))
    }
  }
}
