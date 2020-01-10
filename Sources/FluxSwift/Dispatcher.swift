//
//  Dispatcher.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/10.
//

import Foundation
import RxSwift
import RxRelay

public final class Dispatcher {
    public static let shared = Dispatcher()
    private init() {}
    
    public func register<StoreType: Store>(_ store: StoreType) -> RegisteredStore<StoreType> {
        let registered = RegisteredStore(entity: store)
        storeHolder(for: StoreType.self).append(store: registered)
        return registered
    }
    
    public func dispatch<ActionType: Action>(_ action: ActionType) {
        storeHolder(for: ActionType.StoreType.self).apply(action: action)
    }
    
    public func dispatch<ActionType: ThrowsAction>(_ action: ActionType) throws {
        try storeHolder(for: ActionType.StoreType.self).apply(action: action)
    }
    
    private var storeHolders = [String: Any]()

    private func storeHolder<StoreType: Store>(for type: StoreType.Type) -> RegisteredStoresHolder<StoreType> {
        let key = String(describing: StoreType.self)
        if let storeHolder = storeHolders[key] as? RegisteredStoresHolder<StoreType> { return storeHolder }
        let storeHolder = RegisteredStoresHolder<StoreType>()
        storeHolders[key] = storeHolder
        return storeHolder
    }

    private final class RegisteredStoresHolder<StoreType: Store> {
        typealias RegisteredStoreType = RegisteredStore<StoreType>
        private var weakStores = [WeakHolder<RegisteredStoreType>]()
        
        func append(store: RegisteredStoreType) {
            weakStores.append(WeakHolder(value: store))
        }
        
        func apply<ActionType: Action>(action: ActionType) where ActionType.StoreType == StoreType {
            each { $0.apply(action: action) }
        }
        
        func apply<ActionType: ThrowsAction>(action: ActionType) throws where ActionType.StoreType == StoreType {
            try each { try $0.apply(action: action) }
        }
        
        private func each(handler: (RegisteredStoreType) throws -> Void) rethrows {
            for (index, weakStore) in weakStores.enumerated().reversed() {
                if let store = weakStore.value {
                    try handler(store)
                } else {
                    weakStores.remove(at: index)
                }
            }
        }
    }
}
