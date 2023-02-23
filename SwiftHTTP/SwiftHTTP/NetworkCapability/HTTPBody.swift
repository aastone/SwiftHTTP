//
//  HTTPBody.swift
//  SwiftHTTP
//
//  Created by Yipu Wang on 2/22/23.
//

import Foundation

public protocol HTTPBody {
    func encode() throws -> Data

    var isEmpty: Bool { get }
    var additionalHeaders: [String: String] { get }
}

extension HTTPBody {
    public var isEmpty: Bool { return false }
    public var additionalHeaders: [String: String] { return [:] }
}

public struct EmptyBody: HTTPBody {
    public let isEmpty = true

    public init() { }
    public func encode() throws -> Data { Data() }
}

public struct DataBody: HTTPBody {
    private let data: Data

    public var isEmpty: Bool { data.isEmpty }
    public var additionalHeaders: [String: String]

    public init(_ data: Data, additionalHeaders: [String: String] = [:]) {
        self.data = data
        self.additionalHeaders = additionalHeaders
    }

    public func encode() throws -> Data { data }
}

public struct JSONBody: HTTPBody {
    public let isEmpty: Bool = false
    public var additionalHeaders = [
        "Content-Type": "application/json; charset=utf-8"
    ]

    private let encodedData: () throws -> Data

    public init<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) {
        self.encodedData = { try encoder.encode(value) }
    }

    public func encode() throws -> Data { return try encodedData() }
}

