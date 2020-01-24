//
//  ObservableDispatchActionTests.swift
//  FluxSwiftTests
//
//  Created by Koji Murata on 2020/01/24.
//

import XCTest
import RxSwift
import RxRelay
@testable import FluxSwift

class ObservableDispatchActionTests: XCTestCase {
    func test() {
        let store = Store().register()
        let relay = PublishRelay<Int>()
        let disposable = relay.dispatchAction(action: { Store.Set(x: $0) })
        
        XCTAssertEqual(0, store.entity.x)
        relay.accept(1)
        XCTAssertEqual(1, store.entity.x)
        disposable.dispose()
        relay.accept(2)
        XCTAssertEqual(1, store.entity.x)
    }
    
    func testIdentifiable() {
        let a = IdentifiableStore(id: "a").register()
        let b = IdentifiableStore(id: "b").register()
        
        let relay = PublishRelay<Int>()
        let disposable = relay.dispatchAction(action: { IdentifiableStore.Set(x: $0) })
        let aRelay = PublishRelay<Int>()
        let aDisposable = aRelay.dispatchAction(id: "a", action: { IdentifiableStore.Set(x: $0) })
        let bRelay = PublishRelay<Int>()
        let bDisposable = bRelay.dispatchAction(id: { _ in "b" }, action: { IdentifiableStore.Set(x: $0) })

        XCTAssertEqual(0, a.entity.x)
        XCTAssertEqual(0, b.entity.x)
        relay.accept(1)
        XCTAssertEqual(1, a.entity.x)
        XCTAssertEqual(1, b.entity.x)
        aRelay.accept(2)
        XCTAssertEqual(2, a.entity.x)
        XCTAssertEqual(1, b.entity.x)
        bRelay.accept(3)
        XCTAssertEqual(2, a.entity.x)
        XCTAssertEqual(3, b.entity.x)
        disposable.dispose()
        aDisposable.dispose()
        bDisposable.dispose()
        relay.accept(4)
        aRelay.accept(4)
        bRelay.accept(4)
        XCTAssertEqual(2, a.entity.x)
        XCTAssertEqual(3, b.entity.x)
    }
    
    struct Store: FluxSwift.Store {
        var x: Int = 0
        
        struct Set: Action {
            let x: Int
            func reduce(store: Store) -> Store? { Store(x: x) }
        }
    }
    
    struct IdentifiableStore: FluxSwift.IdentifiableStore {
        let id: String
        var x: Int = 0
        
        struct Set: Action {
            let x: Int
            func reduce(store: IdentifiableStore) -> IdentifiableStore? { IdentifiableStore(id: store.id, x: x) }
        }
    }
}
