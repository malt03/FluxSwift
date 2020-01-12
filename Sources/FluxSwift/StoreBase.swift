//
//  StoreBase.swift
//  FluxSwiftTests
//
//  Created by Koji Murata on 2020/01/12.
//

import Foundation
import RxSwift

public protocol StoreBase {
    var childStores: [AnyRegisteredStore] { get }
}

extension StoreBase {
    public var childStores: [AnyRegisteredStore] { [] }
}
