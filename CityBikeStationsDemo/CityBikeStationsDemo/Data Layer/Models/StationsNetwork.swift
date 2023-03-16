//
//  Station.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 14.03.23.
//

import Foundation

// MARK: - NetworkResponse
struct NetworkResponse: Codable {
  let network: Network
}

// MARK: - Network
struct Network: Codable {
  let id: String
  let name: String
  let href: String
  let location: Location
  let company: [String]
  let stations: [Station]
}

// MARK: - Location
struct Location: Codable {
  let city: String
  let country: String
  let latitude: Double
  let longitude: Double
}

// MARK: - Station
struct Station: Codable, Identifiable {
  let id: String
  let name: String
  let emptySlots: Int?
  let freeBikes: Int
  let latitude: Double
  let longitude: Double
  let extra: Extra
  let timestamp: String

  enum CodingKeys: String, CodingKey {
    case emptySlots = "empty_slots"
    case freeBikes = "free_bikes"
    case id, latitude, longitude, name, timestamp, extra
  }
}

// MARK: - Extra
struct Extra: Codable {
  let uid: String
  let bikeUids: [String]
  let number: String
  let slots: Int?

  enum CodingKeys: String, CodingKey {
    case bikeUids = "bike_uids"
    case number, slots, uid
  }
}
