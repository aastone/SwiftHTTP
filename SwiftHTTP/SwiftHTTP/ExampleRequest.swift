//
//  ExampleRequest.swift
//  SwiftHTTP
//
//  Created by Yipu Wang on 3/13/23.
//

import Foundation

public class ExampleAPI {
    private let loader: HTTPLoading = URLSession.shared

    public func requestPeople() async -> HTTPResult? {
        var r = HTTPRequest()
        r.host = ""
        r.path = ""

        return await loader.load(request: r)
    }
}
