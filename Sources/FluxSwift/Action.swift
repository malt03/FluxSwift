//
//  Action.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/10.
//

import Foundation

public protocol Action {
    associatedtype StoreType: StoreBase
    func reduce(store: StoreType) -> StoreType?
}

extension Action where StoreType: Store {
    public func dispatch() { Dispatcher.shared.dispatch(self) }
    public func any() -> AnyAction { AnyAction(action: self) }
    public func throwsAny() -> AnyThrowsAction { AnyThrowsAction(action: self) }
}

extension Action where StoreType: IdentifiableStore {
    public func dispatch() { Dispatcher.shared.dispatch(self) }
    public func dispatch(to id: StoreType.ID) { Dispatcher.shared.dispatch(self, to: id) }
    public func any() -> AnyAction { AnyAction(action: self) }
    public func throwsAny() -> AnyThrowsAction { AnyThrowsAction(action: self) }
}

public protocol ThrowsAction {
    associatedtype StoreType: StoreBase
    func reduce(store: StoreType) throws -> StoreType?
}

extension ThrowsAction where StoreType: Store {
    public func dispatch() throws { try Dispatcher.shared.dispatch(self) }
    public func throwsAny() -> AnyThrowsAction { AnyThrowsAction(action: self) }
}

extension ThrowsAction where StoreType: IdentifiableStore {
    public func dispatch() throws { try Dispatcher.shared.dispatch(self) }
    public func dispatch(to id: StoreType.ID) throws { try Dispatcher.shared.dispatch(self, to: id) }
    public func throwsAny() -> AnyThrowsAction { AnyThrowsAction(action: self) }
}
