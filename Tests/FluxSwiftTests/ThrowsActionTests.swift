//
//  ThrowsActionTests.swift
//  FluxSwiftTests
//
//  Created by Koji Murata on 2020/01/12.
//

import XCTest
@testable import FluxSwift

class ThrowsActionTests: XCTestCase {
    func testUnidentifiable() {
        do {
            XCTAssertNoThrow(try Counter.MyThrowAction().apply())
            let counter = Counter(count: 0).register()
            XCTAssertThrowsError(try Counter.MyThrowAction().apply())
            XCTAssertNoThrow(try Counter.Increment().apply())
            XCTAssertEqual(1, counter.entity.count)
        }
        XCTAssertNoThrow(try Counter.MyThrowAction().apply())
    }
    
    func testIdentifiable() {
        do {
            XCTAssertNoThrow(try IdentifiableCounter.MyThrowAction().apply())
            let counter0 = IdentifiableCounter(id: 0, count: 0).register()
            let counter1 = IdentifiableCounter(id: 1, count: 1).register()
            XCTAssertThrowsError(try IdentifiableCounter.MyThrowAction().apply())
            XCTAssertNoThrow(try IdentifiableCounter.Increment().apply())
            XCTAssertEqual(1, counter0.entity.count)
            XCTAssertEqual(2, counter1.entity.count)
            XCTAssertNoThrow(try IdentifiableCounter.Increment().apply(to: 1))
            XCTAssertEqual(1, counter0.entity.count)
            XCTAssertEqual(3, counter1.entity.count)
        }
        XCTAssertNoThrow(try IdentifiableCounter.MyThrowAction().apply(to: 0))
        XCTAssertNoThrow(try IdentifiableCounter.MyThrowAction().apply())
    }
    
    struct Counter: Store {
        var count: Int
        
        struct Increment: ThrowsAction {
            func reduce(store: Counter) throws -> Counter? {
                var tmp = store
                tmp.count += 1
                return tmp
            }
        }
        
        struct MyThrowAction: ThrowsAction {
            struct MyError: Error {}
            
            func reduce(store: Counter) throws -> Counter? {
                throw MyError()
            }
        }
    }

    struct IdentifiableCounter: IdentifiableStore {
        let id: Int
        var count: Int
        
        struct Increment: ThrowsAction {
            func reduce(store: IdentifiableCounter) throws -> IdentifiableCounter? {
                var tmp = store
                tmp.count += 1
                return tmp
            }
        }
        
        struct MyThrowAction: ThrowsAction {
            struct MyError: Error {}
            
            func reduce(store: IdentifiableCounter) throws -> IdentifiableCounter? {
                throw MyError()
            }
        }
    }

}
