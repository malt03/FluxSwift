//
//  FluxSwiftTests.swift
//  FluxSwiftTests
//
//  Created by Koji Murata on 2020/01/10.
//

import XCTest
@testable import FluxSwift

class FluxSwiftTests: XCTestCase {
   
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let parent = Parent(counter: 0, childCounter: 100).register()
        var parentCounter = 0
        
        let parentDisposable = parent.subscribe(onNext: { (parent) in
            parentCounter += 1
            
            switch parentCounter {
            case 1:
                XCTAssertEqual(parent.counter, 0)
                XCTAssertEqual(parent.child1.entity.counter, 100)
                XCTAssertEqual(parent.child2.entity.counter, 100)
            default:
                XCTAssert(false, "counter: \(parentCounter)")
            }
        })
        
        XCTAssertEqual(parentCounter, 1)
        parentDisposable.dispose()
    }
}

struct Parent: Store {
    var counter: Int
    let child1: RegisteredStore<Child1>
    let child2: RegisteredStore<Child2>
    
    var children: [AnyRegisteredStore] { [child1.any(), child2.any()] }
    
    init(counter: Int, childCounter: Int) {
        self.counter = counter
        
        self.child1 =  Child1(counter: childCounter).register()
        self.child2 =  Child2(counter: childCounter).register()
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
