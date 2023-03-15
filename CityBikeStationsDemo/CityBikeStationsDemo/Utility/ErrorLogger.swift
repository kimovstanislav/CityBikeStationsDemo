//
//  ErrorLogger.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation

class ErrorLogger {
  static func logError(_ error: DetailedError) {
    // Could properly log an error here with some logging service
    print("Error \(error.code): \(error.message)")
  }
}
