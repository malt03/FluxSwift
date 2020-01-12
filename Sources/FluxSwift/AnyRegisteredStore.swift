//
//  AnyRegisteredStore.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/10.
//

import RxSwift

public final class AnyRegisteredStore {
    let didUpdate: Observable<Void>
    
    init<StoreType: StoreBase>(_ registeredStore: RegisteredStore<StoreType>) {
        didUpdate = registeredStore.didUpdate
    }
}
