//
//  ActionSet.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/03/06.
//

import Foundation

public protocol ActionSet {
    var actions: [AnyAction] { get }
}

extension ActionSet {
    public func dispatch() { actions.forEach { $0.dispatch() } }
    
    public func any() -> AnyAction { AnyAction(actionSet: self) }
    public func throwsAny() -> AnyThrowsAction { AnyThrowsAction(actionSet: self) }
}

public protocol ThrowsActionSet {
    var actions: [AnyThrowsAction] { get }
}

extension ThrowsActionSet {
    public func dispatch() throws { try actions.forEach { try $0.dispatch() } }
    
    public func throwsAny() -> AnyThrowsAction { AnyThrowsAction(actionSet: self) }
}
