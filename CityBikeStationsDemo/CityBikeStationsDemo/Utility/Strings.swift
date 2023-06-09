//
//  Strings.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 14.03.23.
//

import Foundation

// If did things properly, could use SwiftGen — https://github.com/SwiftGen/SwiftGen to generate enums for easy access to localized strings.

enum Strings {
  enum Error {
    static let title = "Error"
    static let unknownMessage = "Unknown error. Please try again."
    static let formattedErrorCode = "\n(Error code: %d)"
    
    enum API {
      static let noInternetConnectionTitle = "No internet connection"
      static let noInternetConnectionMessage = "No internet connection description"
      static let internalServerErrorTitle = "Server error"
      static let internalServerErrorMessage = "Server error description"
      static let decodingApiResponseFailedMessage = "Api response object decoding failed"
      static let loadingStationsFromServerErrorMessage = "Failed to load bike stations from server"
    }
    
    enum LocationService {
      static let gettingLocationError = "Failed to get user location"
    }
  }
    
  enum Button {
    static let close = "Close"
    static let retry = "Retry"
  }
  
  enum Screen {
    enum StationsList {
      static let title = "Bike Stations"
      static let noStations = "No bike stations found"
      static let bikesAvailable = "Bikes available: %d"
      static let emptySlotsAvailable = "Empty slots available: %d"
    }
  }
}
