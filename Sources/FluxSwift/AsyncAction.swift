//
//  AsyncAction.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/04/02.
//

import Foundation

public protocol AsyncAction: AnyAction {
    associatedtype ActionType: Action
    func createAction(store: ActionType.StoreType, completion: @escaping (ActionType) -> Void)
}

extension AsyncAction where ActionType.StoreType: Store {
    public func dispatch() { Dispatcher.shared.dispatch(self) }
}

extension AsyncAction where ActionType.StoreType: IdentifiableStore {
    public func dispatch() { Dispatcher.shared.dispatch(self) }
    public func dispatch(to id: ActionType.StoreType.ID) { Dispatcher.shared.dispatch(self, to: id) }
}
