//
//  AsyncAction.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/04/02.
//

import Foundation
import RxSwift

public protocol AsyncAction: AnyAction {
    associatedtype ActionType: Action
    func createAction(store: ActionType.StoreType, completion: @escaping (ActionType) -> Void)
}

extension AsyncAction where ActionType.StoreType: Store {
    public func dispatch() { _ = Dispatcher.shared.dispatch(self).subscribe(onSuccess: nil, onError: nil) }
}

extension AsyncAction where ActionType.StoreType: IdentifiableStore {
    public func dispatch() { _ = Dispatcher.shared.dispatch(self).subscribe(onSuccess: nil, onError: nil) }
    public func dispatch(to id: ActionType.StoreType.ID) { _ = Dispatcher.shared.dispatch(self, to: id).subscribe(onSuccess: nil, onError: nil) }
}

extension AsyncAction {
    public var rx: Reactive<Self> { .init(self) }
}

extension Reactive where Base: AsyncAction, Base.ActionType.StoreType: Store {
    public func dispatch() -> Single<[Base.ActionType.StoreType]> { Dispatcher.shared.dispatch(base) }
}

extension Reactive where Base: AsyncAction, Base.ActionType.StoreType: IdentifiableStore {
    public func dispatch() -> Single<[Base.ActionType.StoreType]> { Dispatcher.shared.dispatch(base) }
    public func dispatch(to id: Base.ActionType.StoreType.ID) -> Single<[Base.ActionType.StoreType]> { Dispatcher.shared.dispatch(base, to: id) }
}

