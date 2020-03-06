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
        let actions = [
            S.Increment().any(),
            T.Increment().any(),
        ]
    }
    
    struct DoubleIncrement: ActionSet {
        let actions = [
            Increment().any(),
            Increment().any(),
        ]
    }
    
    struct ThrowsIncrement: ThrowsActionSet {
        let actions = [
            S.Increment().throwsAny(),
            T.Increment().throwsAny(),
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

