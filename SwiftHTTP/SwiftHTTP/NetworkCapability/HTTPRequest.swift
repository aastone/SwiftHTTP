//
//  HTTPRequest.swift
//  SwiftHTTP
//
//  Created by Yipu Wang on 2/22/23.
//

import Foundation

public struct HTTPRequest {
    let defaultScheme = "https"

    private var urlComponents = URLComponents()
    public var method: HTTPMethod = .get
    public var headers: [String: String] = [:]
    public var body: HTTPBody = EmptyBody()

    public init() {
        urlComponents.scheme = defaultScheme
    }
}

public extension HTTPRequest {
    var scheme: String { urlComponents.scheme ?? defaultScheme }

    var host: String? {
        get { urlComponents.host }
        set { urlComponents.host = newValue }
    }

    var path: String {
        get { urlComponents.path }
        set { urlComponents.path = newValue }
    }
}

public struct HTTPResponse {
    public let request: HTTPRequest
    private let response: HTTPURLResponse
    public let body: Data?

    public var status: HTTPStatus {
        HTTPStatus(rawValue: response.statusCode)
    }

    public var message: String {
        HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }

    public var headers: [AnyHashable: Any] { response.allHeaderFields }
}

public struct HTTPError: Error {
    public let code: Code

    public let request: HTTPRequest
    public let response: HTTPResponse?
    public let underlyingError: Error?

    public enum Code {
        case invalidRequest
        case cannotConnect
        case cancelled
        case insecureConnection
        case invalidResponse
        case unknown
    }
}

public typealias HTTPResult = Result<HTTPResponse, HTTPError>

extension HTTPResult {
    public var request: HTTPRequest {
        switch self {
        case .success(let response): return response.request
        case .failure(let error): return error.request
        }
    }

    public var response: HTTPResponse? {
        switch self {
        case .success(let response): return response
        case .failure(let error): return error.response
        }
    }
}
