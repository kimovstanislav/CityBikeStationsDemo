//
//  Station+Location.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 16.03.23.
//

import Foundation
import CoreLocation

extension Station {
  var location: CLLocation {
    CLLocation(latitude: latitude, longitude: longitude)
  }
}
