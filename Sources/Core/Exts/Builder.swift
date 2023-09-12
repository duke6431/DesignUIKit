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

public protocol SelfCustomizable {
    func custom(_ configuration: (inout Self) -> Void) -> Self
    func updated<Value>(with value: Value, for keyPath: WritableKeyPath<Self, Value>) -> Self
}

public extension SelfCustomizable {
    func custom(_ configuration: (inout Self) -> Void) -> Self {
        var newSelf = self
        configuration(&newSelf)
        return newSelf
    }
    
    func updated<Value>(with value: Value, for keyPath: WritableKeyPath<Self, Value>) -> Self {
        var newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }
}
