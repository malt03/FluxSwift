//
//  RegisteredStore+Codable.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/11.
//

import Foundation

extension RegisteredStore: Encodable where StoreType: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(entity)
    }
}

extension RegisteredStore: Decodable where StoreType: Decodable {
    public convenience init(from decoder: Decoder) throws {
        self.init(entity: try decoder.singleValueContainer().decode(StoreType.self))
    }
}
