//
//  MockHTTPRequest.swift
//  SwiftHTTP
//
//  Created by Yipu Wang on 3/13/23.
//

import Foundation

public class MockLoader: HTTPLoader {

    public typealias HTTPHandler = (HTTPResult) -> Void

    public override func load(request: HTTPRequest) async -> HTTPResult? {
        let urlResponse = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: "1.1",
            headerFields: nil)!

        let response = HTTPResponse(
            request: request,
            response: urlResponse,
            body: nil)

        return .success(response)
    }
}
