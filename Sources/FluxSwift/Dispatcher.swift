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

    public func register<StoreType: Store>(_ store: StoreType) -> Observable<StoreType> {
        
    }
    
    private var stores = [String: [Any]]()
}
