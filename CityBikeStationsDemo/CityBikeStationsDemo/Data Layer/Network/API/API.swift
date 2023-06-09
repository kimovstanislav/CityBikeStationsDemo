//
//  API.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 14.03.23.
//

import Foundation

protocol API: AnyObject {
  func loadViennaNetwork() async throws -> Network
}

// MARK: - Decode response
extension API {
  func decodeApiResponse<ResponseType: Decodable>(data: Data) throws -> ResponseType {
    do {
      let object = try JSONDecoder().decode(ResponseType.self, from: data)
      return object
    } catch let error {
      let detailedError: DetailedError = DetailedError.Factory.makeDecodingError(cause: error)
      throw detailedError
    }
  }
}
