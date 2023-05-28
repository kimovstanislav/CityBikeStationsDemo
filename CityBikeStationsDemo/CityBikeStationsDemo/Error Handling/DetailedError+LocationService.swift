//
//  DetailedError+LocationService.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 28.05.23.
//

import Foundation

// MARK: - API error init
extension DetailedError {
  init(
    locationServiceError: Error?,
    code: Int,
    title: String,
    message: String
  ) {
    self.init(
      source: .locationService,
      code: code,
      message: message,
      isSilent: false,
      cause: locationServiceError
    )
  }
}

// MARK: - Make decoding error
extension DetailedError.Factory {
  static func makeLocationServiceError(cause: Error? = nil) -> DetailedError {
    DetailedError(
      apiError: cause,
      code: DetailedError.ErrorCode.errorGettingUserLocation.rawValue,
      title: Strings.Error.title,
      message: Strings.Error.LocationService.gettingLocationError)
  }
}
