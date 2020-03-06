//
//  Observable+dispatchAction.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/24.
//

import RxSwift

extension ObservableType {
    public func dispatchAction(action: @escaping (Element) -> AnyAction) -> Disposable {
        subscribe(onNext: { action($0).dispatch() })
    }
    
    public func dispatchAction<ActionType: Action>(id: @escaping (Element) -> ActionType.StoreType.ID, action: @escaping (Element) -> ActionType) -> Disposable where ActionType.StoreType: IdentifiableStore {
        subscribe(onNext: { action($0).dispatch(to: id($0)) })
    }
    
    public func dispatchAction<ActionType: Action>(id: ActionType.StoreType.ID, action: @escaping (Element) -> ActionType) -> Disposable where ActionType.StoreType: IdentifiableStore {
        subscribe(onNext: { action($0).dispatch(to: id) })
    }
}
