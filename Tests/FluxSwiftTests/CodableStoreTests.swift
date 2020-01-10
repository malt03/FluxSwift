//
//  CodableStoreTests.swift
//  FluxSwiftTests
//
//  Created by Koji Murata on 2020/01/11.
//

import XCTest
import Foundation
@testable import FluxSwift

class CodableStoreTests: XCTestCase {
    func testExample() {
        let json = """
        {
          "a" : 1,
          "child" : {
            "b" : 2
          }
        }
        """.data(using: .utf8)!
        let decoded = try! JSONDecoder().decode(RegisteredStore<Parent>.self, from: json)
        
        XCTAssertEqual(1, decoded.entity.a)
        XCTAssertEqual(2, decoded.entity.child.entity.b)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encoded = try! encoder.encode(decoded)
        XCTAssertEqual(json, encoded)
    }

    struct Parent: Store, Codable {
        let a: Int
        let child: RegisteredStore<Child>
        
        var childStores: [AnyRegisteredStore] { [child.any()] }
    }
    
    struct Child: Store, Codable {
        let b: Int
    }
}

