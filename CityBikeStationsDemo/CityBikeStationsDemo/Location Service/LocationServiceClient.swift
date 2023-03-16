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
    locationManager.requestWhenInUseAuthorization()
  }
}

// MARK: - CLLocationManagerDelegate
extension LocationServiceClient: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("> didChangeAuthorization", status.rawValue)
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      locationManager.requestLocation()
    }
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    print("> didUpdateLocations", locations)
    if let location = locations.first {
      completionHandler?(.success(location))
    }
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print("> didFailWithError", error)
    completionHandler?(.failure(error))
  }
}
