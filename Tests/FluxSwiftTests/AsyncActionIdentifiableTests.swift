//
//  AsyncActionIdentifiableTests.swift
//  FluxSwiftTests
//
//  Created by Koji Murata on 2020/08/28.
//

import XCTest
import RxSwift
@testable import FluxSwift

class AsyncActionIdentifiableTests: XCTestCase {
    func test() {
        let a = Counter(id: "a", count: 0).register()
        let b = Counter(id: "b", count: 0).register()
        
        Counter.ChangeValue(isIncrement: true).dispatch(to: "a")
        XCTAssertEqual(1, a.entity.count)
        XCTAssertEqual(0, b.entity.count)
        
        Counter.ChangeValue(isIncrement: true).dispatch()
        XCTAssertEqual(2, a.entity.count)
        XCTAssertEqual(1, b.entity.count)
        
        Counter.ChangeValue(isIncrement: false).dispatch()
        XCTAssertEqual(1, a.entity.count)
        XCTAssertEqual(0, b.entity.count)
        
        Counter.ChangeValue(isIncrement: false).dispatch(to: "b")
        XCTAssertEqual(1, a.entity.count)
        XCTAssertEqual(-1, b.entity.count)
    }
    
    struct Counter: IdentifiableStore {
        let id: String
        var count: Int
        
        struct ChangeValue: AsyncAction {
            let isIncrement: Bool
            func createAction(store: Counter) -> Single<TypeErasedAction<Counter>> {
                .create { (observer) -> Disposable in
                    DispatchQueue.global().sync {
                        if self.isIncrement {
                            observer(.success(Increment().eraseType()))
                        } else {
                            observer(.success(Decrement().eraseType()))
                        }
                    }
                    return Disposables.create()
                }
            }
        }
        
        struct Increment: Action {
            func reduce(store: Counter) -> Counter? {
                var tmp = store
                tmp.count += 1
                return tmp
            }
        }
        
        struct Decrement: Action {
            func reduce(store: Counter) -> Counter? {
                var tmp = store
                tmp.count -= 1
                return tmp
            }
        }
    }
}
