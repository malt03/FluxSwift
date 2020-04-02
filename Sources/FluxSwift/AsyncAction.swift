//
//  AsyncAction.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/04/02.
//

import Foundation

public protocol AsyncAction: AnyAction {
    associatedtype StoreType: StoreBase
    func reduce(store: StoreType, completion: @escaping (StoreType) -> Void)
}

extension AsyncAction where StoreType: Store {
    public func dispatch() { Dispatcher.shared.dispatch(self) }
}

extension AsyncAction where StoreType: IdentifiableStore {
    public func dispatch() { Dispatcher.shared.dispatch(self) }
    public func dispatch(to id: StoreType.ID) { Dispatcher.shared.dispatch(self, to: id) }
}
