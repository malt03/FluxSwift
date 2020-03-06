//
//  ActionSetTests.swift
//  FluxSwiftTests
//
//  Created by Koji Murata on 2020/03/06.
//

import XCTest
import Foundation
@testable import FluxSwift

class ActionSetTests: XCTestCase {
    struct S: Store {
        var x = 0
        
        struct Increment: Action {
            func reduce(store: S) -> S? { S(x: store.x + 1) }
        }
    }
    
    struct T: Store {
        var x = 0
        struct Increment: Action {
            func reduce(store: T) -> T? { T(x: store.x + 1) }
        }
    }
    
    struct Increment: ActionSet {
        let actions: [Dispatchable] = [
            S.Increment(),
            T.Increment(),
        ]
    }
    
    struct DoubleIncrement: ActionSet {
        let actions: [Dispatchable] = [
            Increment(),
            Increment(),
        ]
    }
    
    struct ThrowsIncrement: ThrowsActionSet {
        let actions: [ThrowsDispatchable] = [
            S.Increment(),
            T.Increment(),
        ]
    }
    
    func testExample() {
        let s = S().register()
        let t = T().register()
        
        Increment().dispatch()
        
        XCTAssertEqual(1, s.entity.x)
        XCTAssertEqual(1, t.entity.x)
        
        DoubleIncrement().dispatch()

        XCTAssertEqual(3, s.entity.x)
        XCTAssertEqual(3, t.entity.x)
        
        try! ThrowsIncrement().dispatch()
        
        XCTAssertEqual(4, s.entity.x)
        XCTAssertEqual(4, t.entity.x)
    }
}

