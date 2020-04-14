//
//  AsyncAction.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/04/02.
//

import Foundation

public protocol AsyncAction: AnyAction {
    associatedtype ActionType: Action
    func createAction(completion: @escaping (ActionType) -> Void)
}

extension AsyncAction where ActionType.StoreType: Store {
    public func dispatch() { createAction { $0.dispatch() } }
}

extension AsyncAction where ActionType.StoreType: IdentifiableStore {
    public func dispatch() { createAction { $0.dispatch() } }
    public func dispatch(to id: ActionType.StoreType.ID) { createAction { $0.dispatch(to: id) } }
}
