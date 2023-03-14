//
//  DetailedError+API.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 14.03.23.
//

import Foundation

// MARK: - API error init
extension DetailedError {
  init(
    apiError: Error?,
    code: Int,
    title: String,
    message: String
  ) {
    self.init(
      source: .api,
      code: code,
      message: message,
      isSilent: false,
      cause: apiError
    )
  }
}

// MARK: - Make decoding error
extension DetailedError.Factory {
  static func makeDecodingError(cause: Error? = nil) -> DetailedError {
    DetailedError(
      apiError: cause,
      code: DetailedError.ErrorCode.errorDecodingApiResponse.rawValue,
      title: Strings.Error.API.title,
      message: Strings.Error.API.decodingApiResponseFailedMessage)
  }
}
