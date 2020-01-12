//
//  Dispatcher.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/10.
//

import Foundation
import RxSwift
import RxRelay

final class Dispatcher {
    static let shared = Dispatcher()
    private init() {}
    
    func register<StoreType: Store>(_ store: StoreType) -> RegisteredStore<StoreType> {
        let registered = RegisteredStore(entity: store)
        storeHolder(for: RegisteredUnidentifiableStoresHolder<StoreType>.self).append(store: registered)
        return registered
    }
    
    func register<StoreType: IdentifiableStore>(_ store: StoreType) -> RegisteredStore<StoreType> {
        let registered = RegisteredStore(entity: store)
        storeHolder(for: RegisteredIdentifiableStoresHolder<StoreType>.self).append(store: registered)
        return registered
    }
    
    func dispatch<ActionType: Action>(_ action: ActionType) where ActionType.StoreType: Store {
        storeHolder(for: RegisteredUnidentifiableStoresHolder<ActionType.StoreType>.self).apply(action: action)
    }
    
    func dispatch<ActionType: ThrowsAction>(_ action: ActionType) throws where ActionType.StoreType: Store {
        try storeHolder(for: RegisteredUnidentifiableStoresHolder<ActionType.StoreType>.self).apply(action: action)
    }
    
    func dispatch<ActionType: Action>(_ action: ActionType) where ActionType.StoreType: IdentifiableStore {
        storeHolder(for: RegisteredIdentifiableStoresHolder<ActionType.StoreType>.self).apply(action: action)
    }
    
    func dispatch<ActionType: ThrowsAction>(_ action: ActionType) throws where ActionType.StoreType: IdentifiableStore {
        try storeHolder(for: RegisteredIdentifiableStoresHolder<ActionType.StoreType>.self).apply(action: action)
    }
    
    func dispatch<ActionType: Action>(_ action: ActionType, to id: ActionType.StoreType.ID) where ActionType.StoreType: IdentifiableStore {
        storeHolder(for: RegisteredIdentifiableStoresHolder<ActionType.StoreType>.self).apply(action: action, to: id)
    }
    
    func dispatch<ActionType: ThrowsAction>(_ action: ActionType, to id: ActionType.StoreType.ID) throws where ActionType.StoreType: IdentifiableStore {
        try storeHolder(for: RegisteredIdentifiableStoresHolder<ActionType.StoreType>.self).apply(action: action, to: id)
    }
    
    private var storeHolders = [String: Any]()

    private func storeHolder<HolderType: RegisteredStoresHolder>(for type: HolderType.Type) -> HolderType {
        let key = String(describing: HolderType.StoreType.self)
        if let storeHolder = storeHolders[key] as? HolderType { return storeHolder }
        let storeHolder = HolderType()
        storeHolders[key] = storeHolder
        return storeHolder
    }
}
