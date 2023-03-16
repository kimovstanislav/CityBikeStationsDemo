//
//  LocationServiceClient.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import CoreLocation

// TODO: think about if worth making it an Actor later.
class LocationServiceClient: NSObject, LocationService {
  private var locationManager = CLLocationManager()
  
  typealias LocationClosure = (Result<CLLocation, Error>) -> Void
  private var completionHandler: LocationClosure? = nil
  
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
    locationManager.delegate = self
    
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
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    requestLocationOnceIfAllowed()
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    if let location = locations.first {
      completionHandler?(.success(location))
    }
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    completionHandler?(.failure(error))
  }
}
