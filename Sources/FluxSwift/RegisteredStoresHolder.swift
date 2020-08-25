//
//  RegisteredStoresHolder.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/11.
//

import Foundation
import RxSwift

protocol RegisteredStoresHolder {
    associatedtype StoreType: StoreBase
    typealias RegisteredStoreType = RegisteredStore<StoreType>

    func append(store: RegisteredStoreType)
    
    @discardableResult
    func each<T>(handler: (RegisteredStoreType) throws -> T) rethrows -> [T]
    init()
}

extension RegisteredStoresHolder {
    func apply<ActionType: Action>(action: ActionType) where ActionType.StoreType == StoreType {
        each { $0.apply(action: action) }
    }
    
    func apply<ActionType: ThrowsAction>(action: ActionType) throws where ActionType.StoreType == StoreType {
        try each { try $0.apply(action: action) }
    }

    func apply<ActionType: AsyncAction>(action: ActionType) -> Single<[StoreType]> where ActionType.StoreType == StoreType {
        Single.zip(each { $0.apply(action: action) })
    }
}

final class RegisteredUnidentifiableStoresHolder<StoreType: Store>: RegisteredStoresHolder {
    typealias RegisteredStoreType = RegisteredStore<StoreType>
    private var weakStores = [WeakHolder<RegisteredStoreType>]()
    
    func append(store: RegisteredStoreType) {
        weakStores.append(WeakHolder(value: store))
    }
    
    func each<T>(handler: (RegisteredStoreType) throws -> T) rethrows -> [T] {
        try weakStores.enumerated().reversed().compactMap { (index, weakStore) -> T? in
            if let store = weakStore.value {
                return try handler(store)
            } else {
                weakStores.remove(at: index)
                return nil
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
    
    @discardableResult
    private func each<T>(for id: StoreType.ID, handler: (RegisteredStoreType) throws -> T) rethrows -> [T] {
        try (weakStoresDict[id] ?? []).enumerated().reversed().compactMap { (index, weakStore) -> T? in
            if let store = weakStore.value {
                return try handler(store)
            } else {
                weakStoresDict[id]?.remove(at: index)
                return nil
            }
        }
    }

    func each<T>(handler: (RegisteredStoreType) throws -> T) rethrows -> [T] {
        try weakStoresDict.keys.flatMap { try each(for: $0, handler: handler) }
    }
}
