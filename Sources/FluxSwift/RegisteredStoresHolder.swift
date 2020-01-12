//
//  RegisteredStoresHolder.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/11.
//

import Foundation

protocol RegisteredStoresHolder {
    associatedtype StoreType: StoreBase
    typealias RegisteredStoreType = RegisteredStore<StoreType>

    func append(store: RegisteredStoreType)
    func each(handler: (RegisteredStoreType) throws -> Void) rethrows
    init()
}

extension RegisteredStoresHolder {
    func apply<ActionType: Action>(action: ActionType) where ActionType.StoreType == StoreType {
        each { $0.apply(action: action) }
    }
    
    func apply<ActionType: ThrowsAction>(action: ActionType) throws where ActionType.StoreType == StoreType {
        try each { try $0.apply(action: action) }
    }
}

final class RegisteredUnidentifiableStoresHolder<StoreType: Store>: RegisteredStoresHolder {
    typealias RegisteredStoreType = RegisteredStore<StoreType>
    private var weakStores = [WeakHolder<RegisteredStoreType>]()
    
    func append(store: RegisteredStoreType) {
        weakStores.append(WeakHolder(value: store))
    }
    
    func each(handler: (RegisteredStoreType) throws -> Void) rethrows {
        for (index, weakStore) in weakStores.enumerated().reversed() {
            if let store = weakStore.value {
                try handler(store)
            } else {
                weakStores.remove(at: index)
            }
        }
    }
}

final class RegisteredIdentifiableStoresHolder<StoreType: IdentifiableStore>: RegisteredStoresHolder {
    typealias RegisteredStoreType = RegisteredStore<StoreType>
    private var weakStores = [StoreType.ID: WeakHolder<RegisteredStoreType>]()
    
    func append(store: RegisteredStoreType) {
        weakStores[store.entity.id] = WeakHolder(value: store)
    }
    
    func apply<ActionType: Action>(action: ActionType, to key: StoreType.ID) where ActionType.StoreType == StoreType {
        guard let store = weakStores[key]?.value else {
            weakStores.removeValue(forKey: key)
            return
        }
        store.apply(action: action)
    }
    
    func apply<ActionType: ThrowsAction>(action: ActionType, to key: StoreType.ID) throws where ActionType.StoreType == StoreType {
        guard let store = weakStores[key]?.value else {
            weakStores.removeValue(forKey: key)
            return
        }
        try store.apply(action: action)
    }

    func each(handler: (RegisteredStoreType) throws -> Void) rethrows {
        for (key, weakStore) in weakStores {
            if let store = weakStore.value {
                try handler(store)
            } else {
                weakStores.removeValue(forKey: key)
            }
        }
    }
}
