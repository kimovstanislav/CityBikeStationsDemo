//
//  CBError.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 14.03.23.
//

import Foundation

// TODO: may remove isSilent and location to simplify for a current small demo
struct DetailedError: Error {
  let source: Source
  /// The status code of the error
  let code: Int
  /// The error title
  let title: String
  /// The error message
  let message: String
  /// Indicates whether the error will be shown to the user
  let isSilent: Bool
  /// The underlying error that caused this error
  let cause: Error?
  /// Error location in code, for internal logging
  let location: String

  init(
    source: DetailedError.Source = .unknown,
    code: Int,
    title: String = Strings.Error.API.title,
    message: String,
    isSilent: Bool = false,
    cause: Error? = nil,
    file: String = #file,
    function: String = #function,
    line: Int = #line
  ) {
    self.source = source
    self.code = code
    self.title = title
    self.message = message + String(format: Strings.Error.API.formattedErrorCode, code)
    self.isSilent = isSilent
    self.cause = cause
    location = "\(file):\(line), \(function)"
  }

  static let unknown = DetailedError(
    source: .unknown,
    code: ErrorCode.unknown.rawValue,
    title: Strings.Error.API.title,
    message: Strings.Error.API.unknownMessage
  )
}

// MARK: - Source
extension DetailedError {
  enum Source: String {
    case api, unknown
  }
}

// MARK: - ErrorCode
extension DetailedError {
  enum ErrorCode: Int {
    case unknown = -1
    case unexpectedCodePath = 0
    case errorDecodingApiResponse = 601
  }
}

// MARK: - Factory
extension DetailedError {
  enum Factory {}
}
