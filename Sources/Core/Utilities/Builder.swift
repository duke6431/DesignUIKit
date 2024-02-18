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
    
    @discardableResult
    func customized(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}

public protocol SelfCustomizable {
    @discardableResult
    func custom(_ configuration: (inout Self) -> Void) -> Self
    @discardableResult
    func updated<Value>(_ keyPath: WritableKeyPath<Self, Value>, with value: Value) -> Self
}

public extension SelfCustomizable {
    @discardableResult
    func custom(_ configuration: (inout Self) -> Void) -> Self {
        var newSelf = self
        configuration(&newSelf)
        return newSelf
    }

    @discardableResult
    func updated<Value>(_ keyPath: WritableKeyPath<Self, Value>, with value: Value) -> Self {
        var newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }
}
