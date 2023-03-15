//
//  HTTPStatusCodes.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 14.03.23.
//

import Foundation

enum HTTPStatusCode: Int, Error {
  // MARK: - Server Error - 5xx
  
  /// A generic error message, given when an unexpected condition was encountered and no more specific message is suitable.
  case internalServerError = 500
}
