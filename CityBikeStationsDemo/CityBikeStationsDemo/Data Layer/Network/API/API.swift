//
//  API.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 14.03.23.
//

import Foundation

protocol API {
    /// Throws DetailedError
    func loadNetwork() async throws -> [Network]
}

extension API {
    func decodeApiResponse<T: Decodable>(data: Data) throws -> T {
        do {
            let object: T = try JSONDecoder().decode(T.self, from: data)
            return object
        }
        catch let error {
            let detailedError: DetailedError = DetailedError.Factory.makeDecodingError(cause: error)
            throw detailedError
        }
    }
}
