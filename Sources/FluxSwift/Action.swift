//
//  Action.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/10.
//

import Foundation

public protocol Action {
    associatedtype StoreType: Store
    func reduce(store: StoreType) -> StoreType?
}

extension Action {
    public func run() { Dispatcher.shared.dispatch(self) }
}

public protocol ThrowsAction {
    associatedtype StoreType: Store
    func reduce(store: StoreType) throws -> StoreType?
}

extension ThrowsAction {
    public func run() throws { try Dispatcher.shared.dispatch(self) }
}
