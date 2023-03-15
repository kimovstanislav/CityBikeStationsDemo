//
//  MockAPIClient.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 14.03.23.
//

import Foundation

actor MockAPIClient: API {
  enum MockJsonFiles {
    static let viennaStationsNetwork = "vienna_stations_network"
  }
  
  func loadViennaNetwork() async throws -> Network {
    let response: NetworkResponse = try getObject(fileName: MockJsonFiles.viennaStationsNetwork)
    return response.network
  }
}

extension MockAPIClient {
  func getObject<T: Decodable>(fileName: String) throws -> T {
    let jsonString = JsonHelper.readJsonString(named: fileName)
    let data = jsonString.data(using: .utf8)!
    return try decodeApiResponse(data: data)
  }
}
