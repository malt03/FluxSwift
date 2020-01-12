//
//  IdentifiableStore.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/11.
//

import Foundation

public protocol IdentifiableStore: StoreBase {
    associatedtype ID: Hashable
    var id: ID { get }
}

extension IdentifiableStore {
    public func register() -> RegisteredStore<Self> { Dispatcher.shared.register(self) }
}
