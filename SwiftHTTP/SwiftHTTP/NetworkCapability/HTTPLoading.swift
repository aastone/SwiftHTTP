//
//  HTTPLoading.swift
//  SwiftHTTP
//
//  Created by Yipu Wang on 3/9/23.
//

import Foundation

public protocol HTTPLoading {
    func load(request: HTTPRequest) async -> HTTPResult?
}

open class HTTPLoader {
    public var nextLoader: HTTPLoader? {
        willSet {
            guard nextLoader == nil else { fatalError("The nextLoader may only be set once") }
        }
    }

    public init() { }

    ///   func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void)
    //TODO: - Remove optional return value
    open func load(request: HTTPRequest) async -> HTTPResult? {
        if let next = nextLoader {
            return await next.load(request: request)
        } else {
            let error = HTTPError(code: .cannotConnect, request: request, response: nil, underlyingError: nil)
            return .failure(error)
        }
    }
}

extension URLSession: HTTPLoading {
    public func load(request: HTTPRequest) async -> HTTPResult? {
        guard let url = request.url else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        for (header, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }

        if request.body.isEmpty == false {
            for (header, value) in request.body.additionalHeaders {
                urlRequest.addValue(value, forHTTPHeaderField: header)
            }

            do {
                urlRequest.httpBody = try request.body.encode()
            } catch {
                return .failure(.init(code: .invalidRequest, request: request, response: nil, underlyingError: nil))
            }
        }

        //TODO: - Add dataTask to return a success result
        return await withCheckedContinuation({ continuation in
            dataTask(with: urlRequest) { data, response, error in
                if error != nil {
//                    let result = HTTPResult.success(.init(request: request, response: HTTPURLResponse(url: response?.url, statusCode: response.stat, httpVersion: <#T##String?#>, headerFields: <#T##[String : String]?#>), body: data))
                    continuation.resume(with: .success(nil))
                }
            }.resume()
        })
    }
}
