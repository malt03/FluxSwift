//
//  TypeErasedAction.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/08/25.
//

import Foundation

public struct TypeErasedAction<StoreType> {
    let _reduce: (StoreType) -> StoreType?
    init<ActionType: Action>(action: ActionType) where ActionType.StoreType == StoreType {
        _reduce = action.reduce
    }
    public func reduce(store: StoreType) -> StoreType? { _reduce(store) }
}

extension Action {
    public func eraseType() -> TypeErasedAction<Self.StoreType> {
        .init(action: self)
    }
}
