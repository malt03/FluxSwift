//
//  AnyAction.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/03/06.
//

import Foundation

public final class AnyAction {
    private let _dispatch: () -> Void
    public func dispatch() { _dispatch() }

    init<ActionType: Action>(action: ActionType) where ActionType.StoreType: Store { _dispatch = action.dispatch }
    init<ActionType: Action>(action: ActionType) where ActionType.StoreType: IdentifiableStore { _dispatch = action.dispatch }
    init(actionSet: ActionSet) { _dispatch = actionSet.dispatch }
}

public final class AnyThrowsAction {
    private let _dispatch: () throws -> Void
    public func dispatch() throws { try _dispatch() }

    init<ActionType: Action>(action: ActionType) where ActionType.StoreType: Store { _dispatch = action.dispatch }
    init<ActionType: Action>(action: ActionType) where ActionType.StoreType: IdentifiableStore { _dispatch = action.dispatch }
    init<ActionType: ThrowsAction>(action: ActionType) where ActionType.StoreType: Store { _dispatch = action.dispatch }
    init<ActionType: ThrowsAction>(action: ActionType) where ActionType.StoreType: IdentifiableStore { _dispatch = action.dispatch }
    init(actionSet: ActionSet) { _dispatch = actionSet.dispatch }
    init(actionSet: ThrowsActionSet) { _dispatch = actionSet.dispatch }
}
