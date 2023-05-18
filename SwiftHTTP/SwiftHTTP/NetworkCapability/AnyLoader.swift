//
//  AnyLoader.swift
//  SwiftHTTP
//
//  Created by Yipu Wang on 3/22/23.
//

import Foundation

class AnyLoader: HTTPLoader {
    private let loader: HTTPLoader

    init(_ other: HTTPLoader) {
        self.loader = other
    }

    override func load(request: HTTPRequest) async -> HTTPResult? {
        await loader.load(request: request)
    }
}


precedencegroup LoaderChainingPrecedence {
    higherThan: NilCoalescingPrecedence
    associativity: right
}

infix operator --> : LoaderChainingPrecedence

@discardableResult
public func --> (lhs: HTTPLoader?, rhs: HTTPLoader?) -> HTTPLoader? {
    lhs?.nextLoader = rhs
    return lhs ?? rhs
}


public class ModifyRequest: HTTPLoader {
    private let modifier: (HTTPRequest) -> HTTPRequest

    public init(modifier: @escaping (HTTPRequest) -> HTTPRequest) {
        self.modifier = modifier
        super.init()
    }

    public override func load(request: HTTPRequest) async -> HTTPResult? {
        let modifiedRequest = modifier(request)

        return await super.load(request: modifiedRequest)
    }
}
