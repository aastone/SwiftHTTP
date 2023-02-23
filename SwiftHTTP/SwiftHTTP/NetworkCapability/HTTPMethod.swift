//
//  HTTPMethod.swift
//  SwiftHTTP
//
//  Created by Yipu Wang on 2/22/23.
//

import Foundation

public struct HTTPMethod: Hashable {
    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")
    public static let delete = HTTPMethod(rawValue: "DELETE")

    public let rawValue: String
}

public struct HTTPStatus: Hashable {
    public let rawValue: Int
}
