//
//  AsyncAction.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/04/02.
//

import Foundation
import RxSwift

public protocol AsyncAction: AnyAction {
    associatedtype StoreType
    func createAction(store: StoreType) -> Single<TypeErasedAction<StoreType>>
}

extension AsyncAction where StoreType: Store {
    public func dispatch() { _ = Dispatcher.shared.dispatch(self).subscribe(onSuccess: nil, onError: nil) }
}

extension AsyncAction where StoreType: IdentifiableStore {
    public func dispatch() { _ = Dispatcher.shared.dispatch(self).subscribe(onSuccess: nil, onError: nil) }
    public func dispatch(to id: StoreType.ID) { _ = Dispatcher.shared.dispatch(self, to: id).subscribe(onSuccess: nil, onError: nil) }
}

extension AsyncAction {
    public var rx: Reactive<Self> { .init(self) }
}

extension Reactive where Base: AsyncAction, Base.StoreType: Store {
    public func dispatch() -> Single<[Base.StoreType]> { Dispatcher.shared.dispatch(base) }
}

extension Reactive where Base: AsyncAction, Base.StoreType: IdentifiableStore {
    public func dispatch() -> Single<[Base.StoreType]> { Dispatcher.shared.dispatch(base) }
    public func dispatch(to id: Base.StoreType.ID) -> Single<[Base.StoreType]> { Dispatcher.shared.dispatch(base, to: id) }
}

