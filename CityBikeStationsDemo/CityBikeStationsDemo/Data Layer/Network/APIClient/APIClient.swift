//
//  APIClient.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 14.03.23.
//

import Foundation

// TODO: try on ViewModel @MainActor, or just update ViewState from MainActor. Output which are things run on the main thread in different places and approaches.
// TODO: figure out if we need an actor and use it correct, also cancelling the request, maybe?
actor APIClient: API {
  let session = URLSession.shared

  enum URLs {
//    static let host = "https://api.citybik.es"
    static let host = "api.citybik.es"
    static let apiVersion = "/v2"

    enum Endpoints {
      static let viennaNetwork = "/networks/wienmobil-rad"
    }
  }

  private func makeUrl(host: String, apiVersion: String, endpoint: String) -> URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = apiVersion + endpoint
    guard let url = components.url else {
      unexpectedCodePath(message: "Invalid URL.")
    }
    return url
  }
  
  func loadViennaNetwork() async throws -> Network {
    let url = makeUrl(
      host: URLs.host,
      apiVersion: URLs.apiVersion,
      endpoint: URLs.Endpoints.viennaNetwork)
    print("> url", url)
    let response: NetworkResponse = try await performRequest(url: url)
    return response.network
  }
}

// MARK: - Perform request and decode data
extension APIClient {
  private func performRequest<ResponseType: Decodable>(url: URL) async throws -> ResponseType {
    let data: Data = try await getDataFromApi(url: url)
    let object: ResponseType = try decodeApiResponse(data: data)
    return object
  }

  private func getDataFromApi(url: URL) async throws -> Data {
    do {
      let (data, _) = try await session.data(from: url)
      return data
    } catch let error {
      let detailedError = APIClient.ErrorMapper.convertToDetailedError(error)
      throw detailedError
    }
  }
}
