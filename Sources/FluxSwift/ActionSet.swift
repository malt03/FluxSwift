//
//  ActionSet.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/03/06.
//

import Foundation

public protocol ActionSet: AnyAction {
    var actions: [AnyAction] { get }
}

extension ActionSet {
    public func dispatch() { actions.forEach { $0.dispatch() } }
}

public protocol ThrowsActionSet: AnyThrowsAction {
    var actions: [AnyThrowsAction] { get }
}

extension ThrowsActionSet {
    public func dispatch() throws { try actions.forEach { try $0.dispatch() } }
}
