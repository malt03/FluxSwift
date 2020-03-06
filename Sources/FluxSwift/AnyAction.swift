//
//  AnyAction.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/03/06.
//

import Foundation

public protocol AnyAction: AnyThrowsAction {
    func dispatch()
}

public protocol AnyThrowsAction {
    func dispatch() throws
}
