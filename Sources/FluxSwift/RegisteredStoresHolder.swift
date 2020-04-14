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

    func apply<ActionType: AsyncAction>(action: ActionType) where ActionType.ActionType.StoreType == StoreType {
        each { $0.apply(action: action) }
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
    private var weakStoresDict = [StoreType.ID: [WeakHolder<RegisteredStoreType>]]()
    
    func append(store: RegisteredStoreType) {
        weakStoresDict[store.entity.id, default: []].append(WeakHolder(value: store))
    }
    
    func apply<ActionType: Action>(action: ActionType, to id: StoreType.ID) where ActionType.StoreType == StoreType {
        each(for: id) { $0.apply(action: action) }
    }
    
    func apply<ActionType: ThrowsAction>(action: ActionType, to id: StoreType.ID) throws where ActionType.StoreType == StoreType {
        try each(for: id) { try $0.apply(action: action) }
    }
    
    private func each(for id: StoreType.ID, handler: (RegisteredStoreType) throws -> Void) rethrows {
        for (index, weakStore) in (weakStoresDict[id] ?? []).enumerated().reversed() {
            if let store = weakStore.value {
                try handler(store)
            } else {
                weakStoresDict[id]?.remove(at: index)
            }
        }
    }

    func each(handler: (RegisteredStoreType) throws -> Void) rethrows {
        for id in weakStoresDict.keys {
            try each(for: id, handler: handler)
        }
    }
}
