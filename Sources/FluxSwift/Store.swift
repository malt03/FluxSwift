//
//  Store.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/10.
//

import Foundation
import RxSwift

public protocol Store {
    var childStores: [AnyRegisteredStore] { get }
}

extension Store {
    public func register() -> RegisteredStore<Self> { Dispatcher.shared.register(self) }
    
    public var childStores: [AnyRegisteredStore] { [] }
}
