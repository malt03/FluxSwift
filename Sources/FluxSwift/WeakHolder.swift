//
//  WeakHolder.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/10.
//

import Foundation

final class WeakHolder<T: AnyObject> {
    private(set) weak var value: T?
    init(value: T) {
        self.value = value
    }
}
