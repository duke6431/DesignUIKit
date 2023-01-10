//
//  Builder.swift
//  DesignCore
//
//  Created by Duc IT. Nguyen Minh on 07/01/2023.
//

import Foundation

public protocol Chainable { }

public extension Chainable where Self: AnyObject {
    @discardableResult
    func with<T>(_ property: ReferenceWritableKeyPath<Self, T>, setTo value: T) -> Self {
        self[keyPath: property] = value
        return self
    }
}
