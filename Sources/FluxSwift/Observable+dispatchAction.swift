//
//  Observable+dispatchAction.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/24.
//

import RxSwift

extension ObservableType {
    func dispatchAction<ActionType: Action>(action: @escaping (Element) -> ActionType) -> Disposable where ActionType.StoreType: Store {
        subscribe(onNext: { action($0).dispatch() })
    }
    
    func dispatchAction<ActionType: Action>(action: @escaping (Element) -> ActionType) -> Disposable where ActionType.StoreType: IdentifiableStore {
        subscribe(onNext: { action($0).dispatch() })
    }
    
    func dispatchAction<ActionType: Action>(id: @escaping (Element) -> ActionType.StoreType.ID, action: @escaping (Element) -> ActionType) -> Disposable where ActionType.StoreType: IdentifiableStore {
        subscribe(onNext: { action($0).dispatch(to: id($0)) })
    }
}
