//
//  Dispatchable.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/03/06.
//

import Foundation

public protocol Dispatchable: ThrowsDispatchable {
    func dispatch()
}

public protocol ThrowsDispatchable {
    func dispatch() throws
}
