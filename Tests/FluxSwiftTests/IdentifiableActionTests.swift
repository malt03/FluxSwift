//
//  IdentifiableActionTests.swift
//  FluxSwiftTests
//
//  Created by Koji Murata on 2020/01/11.
//

import RxSwift
import XCTest
@testable import FluxSwift

class IdentifiableActionTests: XCTestCase {
    func test() {
        let bag = DisposeBag()
        var countFor0 = 0
        var countFor2 = 0
        var countFor4 = 0
        var actionId = -1
        
        let counters = [0, 2, 4].map { Counter(id: $0, count: $0).register() }

        counters[0].subscribe(onNext: { (counter) in
            countFor0 += 1
            switch countFor0 {
            case 1:
                XCTAssertEqual(0, counter.count)
            case 2:
                XCTAssertEqual(1, counter.count)
                XCTAssertEqual(0, actionId)
            case 3:
                XCTAssertEqual(2, counter.count)
                XCTAssertEqual(1, actionId)
            case 4:
                XCTAssertEqual(3, counter.count)
                XCTAssertEqual(4, actionId)
            default:
                XCTAssert(false)
            }
        }).disposed(by: bag)

        counters[1].subscribe(onNext: { (counter) in
            countFor2 += 1
            switch countFor2 {
            case 1:
                XCTAssertEqual(2, counter.count)
            case 2:
                XCTAssertEqual(3, counter.count)
                XCTAssertEqual(1, actionId)
            case 3:
                XCTAssertEqual(4, counter.count)
                XCTAssertEqual(4, actionId)
            default:
                XCTAssert(false)
            }
        }).disposed(by: bag)

        counters[2].subscribe(onNext: { (counter) in
            countFor4 += 1
            switch countFor4 {
            case 1:
                XCTAssertEqual(4, counter.count)
            case 2:
                XCTAssertEqual(5, counter.count)
                XCTAssertEqual(1, actionId)
            case 3:
                XCTAssertEqual(6, counter.count)
                XCTAssertEqual(2, actionId)
            case 4:
                XCTAssertEqual(7, counter.count)
                XCTAssertEqual(3, actionId)
            case 5:
                XCTAssertEqual(8, counter.count)
                XCTAssertEqual(4, actionId)
            default:
                XCTAssert(false)
            }
        }).disposed(by: bag)
        
        print(counters)
        
        actionId = 0
        Counter.Increment().apply(to: 0)
        actionId = 1
        Counter.Increment().apply()
        actionId = 2
        Counter.Increment().apply(to: 4)
        actionId = 3
        Counter.Increment().apply(to: 4)
        actionId = 4
        Counter.Increment().apply()

        XCTAssertEqual(4, countFor0)
        XCTAssertEqual(3, countFor2)
        XCTAssertEqual(5, countFor4)
        XCTAssertEqual(3, counters[0].entity.count)
        XCTAssertEqual(4, counters[1].entity.count)
        XCTAssertEqual(8, counters[2].entity.count)
    }

    struct Counter: IdentifiableStore {
        let id: Int
        var count: Int
        
        struct Increment: Action {
            func reduce(store: Counter) -> Counter? {
                var tmp = store
                tmp.count += 1
                return tmp
            }
        }
    }
}
