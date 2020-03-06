//
//  AnyActionTests.swift
//  FluxSwiftTests
//
//  Created by Koji Murata on 2020/03/06.
//

import XCTest
import Foundation
@testable import FluxSwift

class AnyActionTests: XCTestCase {
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
    
    func testExample() {
        let s = S().register()
        let t = T().register()
        
        S.Increment().dispatch()
        
        XCTAssertEqual(1, s.entity.x)
        XCTAssertEqual(0, t.entity.x)
        
        T.Increment().dispatch()
        
        XCTAssertEqual(1, s.entity.x)
        XCTAssertEqual(1, t.entity.x)
        
        var anyAction = S.Increment().any()
        anyAction.dispatch()

        XCTAssertEqual(2, s.entity.x)
        XCTAssertEqual(1, t.entity.x)

        anyAction = T.Increment().any()
        anyAction.dispatch()

        XCTAssertEqual(2, s.entity.x)
        XCTAssertEqual(2, t.entity.x)

        var throwsAnyAction = S.Increment().throwsAny()
        try! throwsAnyAction.dispatch()

        XCTAssertEqual(3, s.entity.x)
        XCTAssertEqual(2, t.entity.x)

        throwsAnyAction = T.Increment().throwsAny()
        try! throwsAnyAction.dispatch()

        XCTAssertEqual(3, s.entity.x)
        XCTAssertEqual(3, t.entity.x)
    }
}

