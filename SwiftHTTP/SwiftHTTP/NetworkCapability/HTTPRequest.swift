//
//  HTTPRequest.swift
//  SwiftHTTP
//
//  Created by Yipu Wang on 2/22/23.
//

import Foundation

public protocol HTTPRequestOption {
    associatedtype Value

    static var defaultOptionValue: Value { get }
}

public struct HTTPRequest {
    let defaultScheme = "https"

    private var urlComponents = URLComponents()
    public var method: HTTPMethod = .get
    public var headers: [String: String] = [:]
    public var body: HTTPBody = EmptyBody()

    private var options = [ObjectIdentifier: Any]()

    public subscript<x: HTTPRequestOption>(option type: x.Type) -> x.Value {
        get {
            let id = ObjectIdentifier(type)

            // pull out any specified value from the options dictionary, if it's the right type
            // if it's missing or the wrong type, return the defaultOptionValue
            guard let value = options[id] as? x.Value else {
                return type.defaultOptionValue
            }

            return value
        }

        set {
            let id = ObjectIdentifier(type)
            // save the specified value into the options dictionary
            options[id] = newValue
        }
    }

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

    var url: URL? {
        urlComponents.url
    }
}

public struct HTTPResponse {
    public let request: HTTPRequest
    public let response: HTTPURLResponse
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
