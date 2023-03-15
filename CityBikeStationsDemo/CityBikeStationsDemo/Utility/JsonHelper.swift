//
//  JsonHelper.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 14.03.23.
//

import Foundation

enum JsonHelper {
  static func readJsonString(named: String) -> String {
    if let path = Bundle.main.path(forResource: named, ofType: "json") {
      return (try? String(contentsOfFile: path)) ?? ""
    }
    return ""
  }
}
