//
//  FluxSwiftTests.swift
//  FluxSwiftTests
//
//  Created by Koji Murata on 2020/01/10.
//

import XCTest
@testable import FluxSwift

class FluxSwiftTests: XCTestCase {
    func test() {
        let parent = Parent(counter: 0, child1Counter: 2, child2Counter: 4).register()
        var parentCounter = 0
        var child1Counter = 0
        var child2Counter = 0
        
        let parentDisposable = parent.subscribe(onNext: { (parent) in
            parentCounter += 1
            
            switch parentCounter {
            case 1:
                XCTAssertEqual(0, parent.counter)
                XCTAssertEqual(2, parent.child1.entity.counter)
                XCTAssertEqual(4, parent.child2.entity.counter)
            case 2:
                XCTAssertEqual(0, parent.counter)
                XCTAssertEqual(3, parent.child1.entity.counter)
                XCTAssertEqual(4, parent.child2.entity.counter)
            case 3:
                XCTAssertEqual(0, parent.counter)
                XCTAssertEqual(3, parent.child1.entity.counter)
                XCTAssertEqual(5, parent.child2.entity.counter)
            case 4:
                XCTAssertEqual(1, parent.counter)
                XCTAssertEqual(3, parent.child1.entity.counter)
                XCTAssertEqual(5, parent.child2.entity.counter)
            case 5:
                XCTAssertEqual(1, parent.counter)
                XCTAssertEqual(4, parent.child1.entity.counter)
                XCTAssertEqual(5, parent.child2.entity.counter)
            case 6:
                XCTAssertEqual(1, parent.counter)
                XCTAssertEqual(4, parent.child1.entity.counter)
                XCTAssertEqual(6, parent.child2.entity.counter)
            case 7:
                XCTAssertEqual(2, parent.counter)
                XCTAssertEqual(4, parent.child1.entity.counter)
                XCTAssertEqual(6, parent.child2.entity.counter)
            default:
                XCTAssert(false, "counter: \(parentCounter)")
            }
        })
        
        let child1Disposable = parent.entity.child1.subscribe(onNext: { (child1) in
            child1Counter += 1

            switch child1Counter {
            case 1:
                XCTAssertEqual(2, child1.counter)
            case 2:
                XCTAssertEqual(3, child1.counter)
            case 3:
                XCTAssertEqual(4, child1.counter)
            default:
                XCTAssert(false, "counter: \(child1Counter)")
            }
        })
        
        let child2Disposable = parent.entity.child2.subscribe(onNext: { (child2) in
            child2Counter += 1

            switch child2Counter {
            case 1:
                XCTAssertEqual(4, child2.counter)
            case 2:
                XCTAssertEqual(5, child2.counter)
            case 3:
                XCTAssertEqual(6, child2.counter)
            default:
                XCTAssert(false, "counter: \(child2Counter)")
            }
        })
        
        Child1.Increment().apply()
        Child2.Increment().apply()
        Parent.Increment().apply()
        Child1.Increment().apply()
        Child2.Increment().apply()
        Parent.Increment().apply()

        XCTAssertEqual(7, parentCounter)
        XCTAssertEqual(3, child1Counter)
        XCTAssertEqual(3, child2Counter)
        
        parentDisposable.dispose()
        child1Disposable.dispose()
        child2Disposable.dispose()
    }

    struct Parent: Store {
        var counter: Int
        let child1: RegisteredStore<Child1>
        let child2: RegisteredStore<Child2>
        
        var childStores: [AnyRegisteredStore] { [child1.any(), child2.any()] }
        
        init(counter: Int, child1Counter: Int, child2Counter: Int) {
            self.counter = counter
            
            self.child1 = Child1(counter: child1Counter).register()
            self.child2 = Child2(counter: child2Counter).register()
        }
        
        struct Increment: Action {
            func reduce(store: Parent) -> Parent? {
                var tmp = store
                tmp.counter += 1
                return tmp
            }
        }
    }
    
    struct Child1: Store {
        var counter: Int
        
        struct Increment: Action {
            func reduce(store: Child1) -> Child1? {
                var tmp = store
                tmp.counter += 1
                return tmp
            }
        }
    }
    
    struct Child2: Store {
        var counter: Int
        
        struct Increment: Action {
            func reduce(store: Child2) -> Child2? {
                var tmp = store
                tmp.counter += 1
                return tmp
            }
        }
    }
}
