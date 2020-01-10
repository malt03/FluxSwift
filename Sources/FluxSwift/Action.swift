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

public protocol ThrowsAction {
    associatedtype StoreType: Store
    func reduce(store: StoreType) throws -> StoreType?
}
