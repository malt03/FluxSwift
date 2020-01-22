//
//  SameNameStoreTests.swift
//  FluxSwiftTests
//
//  Created by Koji Murata on 2020/01/22.
//

import XCTest
import Foundation
@testable import FluxSwift

class SameNameStoreTests: XCTestCase {
    func test() {
        let a = A.Store().register()
        let b = B.Store().register()
        
        A.Increment().dispatch()
        B.Increment().dispatch()
        B.Increment().dispatch()
        
        XCTAssertEqual(1, a.entity.x)
        XCTAssertEqual(2, b.entity.x)
    }

    class A {
        struct Store: FluxSwift.Store {
            var x: Int = 0
        }
        
        struct Increment: Action {
            func reduce(store: Store) -> Store? {
                var tmp = store
                tmp.x += 1
                return tmp
            }
        }
    }

    class B {
        struct Store: FluxSwift.Store {
            var x: Int = 0
        }
        
        struct Increment: Action {
            func reduce(store: Store) -> Store? {
                var tmp = store
                tmp.x += 1
                return tmp
            }
        }
    }
}
