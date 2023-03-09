//
//  HTTPLoading.swift
//  SwiftHTTP
//
//  Created by Yipu Wang on 3/9/23.
//

import Foundation

public protocol HTTPLoading {
    // TODO: - Use Async to rewrite this method
    func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void)
}
